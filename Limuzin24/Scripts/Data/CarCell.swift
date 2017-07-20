//
//  CarCell.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 07.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation


import UIKit

class CarCell: UITableViewCell {
    
    
    @IBOutlet weak var CarType: UILabel!
    @IBOutlet weak var CarImage: UIImageView!
    @IBOutlet weak var Distanse: UILabel!
    
    @IBOutlet weak var Star5: UIImageView!
    @IBOutlet weak var Star4: UIImageView!
    @IBOutlet weak var Star3: UIImageView!
    @IBOutlet weak var Star2: UIImageView!
    @IBOutlet weak var Star1: UIImageView!
    
    var StarList:[UIImageView]!
    var carId:Int!
    var carRate: Int!
    var isLoading: Bool = false
    var isRateLoading: Bool = false
    var CachImage:UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        StarList = [Star1,Star2,Star3,Star4,Star5]

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func createCell(car : CarShort){
        isLoading = false
        carId = car.carId
        CarType.text = car.carName
        Distanse.text = String(car.distance)
        self.addPicture(car.carImageUrl)
        carRate = Int(car.rate)
        self.setRate(rate: carRate)
        
    }
    
    private func addPicture(_ url:String){
        if(self.isLoading){
            DispatchQueue.main.async
                {
                    self.CarImage.image = UIImage(named: "placeholder.jpg")

            }
            //self.Loading.startAnimating()
        }
        if(!isLoading){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async{
                    self.CachImage =  self.DownloadImage(url)
                    DispatchQueue.main.async
                        {
                            self.CarImage.image = self.CachImage
                            self.isLoading = false
                    }
                    
            }
        }
        
    }
    
    private func setRate(rate:Int){
        if(self.isRateLoading){
            //self.Loading.startAnimating()
        }
        if(!isRateLoading){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                 self.fillStars(count: rate)
                DispatchQueue.main.async
                    {
                        self.isRateLoading = false
                }
                
            }
        }
        
    }
    
    private func fillStars(count:Int){
        self.isRateLoading = true
        var i = 0
        while(i < count && i < 5){
            StarList[i].image = UIImage(named: "star-gold.png")
            i+=1
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
            Image = UIImage(named: "placeholder.jpg")
            }
        if(Image == nil){
            Image = UIImage(named: "placeholder.jpg")

        }
        //self.Loading.stopAnimating()
        return Image!
    }
    
    
    
    
    
}
