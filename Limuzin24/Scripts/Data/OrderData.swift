//
//  OrderData.swift
//  Limuzin
//
//  Created by Khusan Saidvaliev on 06.06.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation

class Order{
    var date:String?
    var fromTime:String?
    var ToTime:String?
    var lat:Double?
    var long:Double?
    var customerName:String?
    var customerNumber:String?
    var orderId:String?
    var status:Int?
    
    
}

class OrderForCustomer:Order{

    var carName:String?
    var carID:Int?

}


import UIKit

class OrderForCustomerCell: UITableViewCell {
    
    
    @IBOutlet weak var fromTime: UILabel!
    @IBOutlet weak var toTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func createCell(order: Order){
        fromTime.text = order.fromTime
        toTime.text = order.ToTime
    }
    

}


class OrderForDriverCell: UITableViewCell {
    
    
    @IBOutlet weak var fromTime: UILabel!
    @IBOutlet weak var toTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func createCell(order: Order){
        fromTime.text = order.fromTime
        toTime.text = order.ToTime
    }
}

class OrderWithDatesForDriverCell: UITableViewCell {
    
    
    @IBOutlet weak var fromTime: UILabel!
    @IBOutlet weak var toTime: UILabel!
    @IBOutlet weak var date: UILabel!

    var orderId:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func createCell(order: Order){
        fromTime.text = order.fromTime
        toTime.text = order.ToTime
        date.text = order.date
        orderId = order.orderId
    }
}

class ResponseObject:UIViewController{
 
    func ResponseManager(response: [String:Any]){

    }

}


    
    
    
    
    
