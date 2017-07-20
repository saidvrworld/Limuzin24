//
//  OfferCell.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 09.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation



import UIKit

class OfferCell: UITableViewCell {
    
    @IBOutlet weak var offerPrice: UILabel!
    var offerId:Int!
    
    @IBOutlet weak var offerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func createCell(offer: Offer){
        
        offerPrice.text = offer.offerPrice
        offerName.text = offer.offerName
        offerId = offer.offerId

    }
    
    
}

class Offer{
   
    var offerName:String!
    var offerPrice:String!
    var offerId:Int!
  

}
