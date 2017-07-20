//
//  SetImages.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 04.05.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SetImages: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var PhoneNumber: UILabel!
    @IBOutlet weak var userName: UILabel!

    @IBOutlet weak var RateView: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var carImage: UIImageView!
    var isCarImageLoading = false
    var isUserImageLoading = false

    var waiting_for:String?
    let imagePicker = UIImagePickerController()
    
    @IBAction func ChooseUserImage(_ sender: Any) {
        waiting_for = "user"
        SetUserImage()
    }
    
    @IBAction func ChooseCarImage(_ sender: Any) {
        waiting_for = "car"
        SetUserImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .popover
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        UpdateDriverInfo()
     }
    
    private func UpdateDriverInfo(){
        MakeRequest(urlstring: AppData.CarInfoUrl, token: AppData.token)

    }
   
    private func MakeRequest(urlstring: String,token: String){
        
        let parameters = "token="+token
        
        print(parameters)
        
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async
                        {
                           // self.ErrorView.isHidden = false
                           // self.ShowErrorConnection()
                    }
                }
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                self.InfoManager(response:responseJSON)
            }
        }
        
        task.resume()
        
    }
    
    private func InfoManager(response: [String:Any]){
        
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                DispatchQueue.main.async{
                self.userName.text = dataBody?["carName"] as? String
                self.PhoneNumber.text = dataBody?["phoneNumber"] as? String
                let rate = dataBody?["rate"] as! Double
                self.RateView.text = String(rate)
                }
                
                setCarPicture(dataBody?["carImageUrl"] as! String)
                setUserPicture(dataBody?["userPhoto"] as! String)
                
                
                
            }
            
        }
        
    }

    private func setCarPicture(_ url:String){
        if(self.isCarImageLoading){
            //self.Loading.startAnimating()
        }
        if(!isCarImageLoading){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    let Img = self.DownloadCarImage(url)
                DispatchQueue.main.async
                    {
                        self.carImage.image = Img
                        self.isCarImageLoading = false
                }
                
            }
        }
    }
    
    private func setUserPicture(_ url:String){
        if(self.isUserImageLoading){
            //self.Loading.startAnimating()
        }
        if(!isUserImageLoading){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                 let Img = self.DownloadUserImage(url)
                DispatchQueue.main.async
                    {
                        self.userImage.image = Img
                        self.isUserImageLoading = false
                }
                
            }
        }
        
    }
    
    
    private func DownloadCarImage(_ imgUrl:String)->UIImage{
        self.isCarImageLoading = true
        var Image: UIImage?
        let url = URL(string:imgUrl)
        let data = try? Data(contentsOf: url!)
        
        if data != nil {
            Image = UIImage(data:data!)
        } else {
            Image = UIImage(named: "image_placeholder.png")
        }
        if(Image == nil){
            Image = UIImage(named: "image_placeholder.png")
        }
        //self.Loading.stopAnimating()
        return Image!
    }
    
    private func DownloadUserImage(_ imgUrl:String)->UIImage{
        self.isUserImageLoading = true
        var Image: UIImage?
        let url = URL(string:imgUrl)
        let data = try? Data(contentsOf: url!)
        
        if data != nil {
            Image = UIImage(data:data!)
        } else {
            Image = UIImage(named: "user_icon.png")
        }
        if(Image == nil){
            Image = UIImage(named: "user_icon.png")
        }
        //self.Loading.stopAnimating()
        return Image!
    }

    func SetUserImage(){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    
    }
    
    @IBAction func BackButton(_ sender: Any) {
        NavigationManager.MoveToDriverMain(View: self)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info.debugDescription)

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if(waiting_for=="user"){
                userImage.contentMode = .scaleAspectFit
                userImage.image = pickedImage
                print(1)
                SendImage(img: pickedImage, urlAddress: AppData.setImageForDriverUrl, name: "userPhoto", token: AppData.token)
                
            }
            else if(waiting_for=="car"){
                carImage.contentMode = .scaleAspectFit
                carImage.image = pickedImage
                SendImage(img: pickedImage, urlAddress: AppData.setImageForDriverUrl, name: "carPhoto", token: AppData.token)
                
            }

        }
        else { print ("error") }
        
        /// if the request successfully done just dismiss
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func SendImage(img:UIImage,urlAddress:String,name:String,token:String){
        
        let img_data: Data = UIImageJPEGRepresentation(img, 0.7)!

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(img_data, withName: "\(name)", fileName: "\(token).jpg", mimeType: "text/plain")
        },
            to: urlAddress,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
        
    }
}

    
   

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}











































