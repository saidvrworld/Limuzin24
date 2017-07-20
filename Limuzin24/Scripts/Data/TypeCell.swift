//
//  TypeCell.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 06.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation


import UIKit
class CarType{
 
    var type: String?
    var id: Int?
    var category: String?
    var imgUrl:String?
    
}


class TypeCell: UITableViewCell {
    
    @IBOutlet weak var Category: UILabel!
    var ID:Int!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Check: UIImageView!
    @IBOutlet weak var CarImage: UIImageView!
    var CachImage:UIImage?
    var isLoading: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func Choose(){
        AppData.carTypeID = String(ID)
        AppData.carType = Name.text
    }
    
    func UnChoose(){
        self.Check.isHidden = true
    }
    
    
    func createCell(type:CarType){
        self.isLoading = false
        Name.text = type.type
        ID = type.id
        addPicture(type.imgUrl!)
        
    }
    
    private func addPicture(_ url:String){
        if(self.isLoading){
            DispatchQueue.main.async
                {
                    self.CarImage.image = UIImage(named: "image_placeholder.png")
            }
            //self.Loading.startAnimating()
        }
        if(!isLoading){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async{
                self.CachImage =  self.DownloadImage(url)
                DispatchQueue.main.async
                    {
                        self.CarImage.image =  self.CachImage
                        self.isLoading = false
                }
            }
        }
    }
    
    private func DownloadImage(_ imgUrl:String)->UIImage{
        self.isLoading = true
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
    
}
