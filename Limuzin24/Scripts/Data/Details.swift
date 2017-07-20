//
//  Details.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 11.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation


class CarDetail{
   
    var details:String!
    var userImage: String!
    var carImage: String!
    var carNumber: String!
    var userName: String!
    var carLength: String!
    var carType: String!
    var driverNumber: String!
    var phoneNumber: String!
    var rate:Int!
    var driverPrice:String!
    var fromH:String!
    var fromM:String!
    var toH:String!
    var toM:String!

}

class OfferDetail{
    

    var price:String!
    var details:String!
    var userImage: String!
    var carImage: String!
    var carNumber: String!
    var userName: String!
    var carWeigth: String!
    var carType: String!
    var driverNumber: String!
    var phoneNumber: String!
    var rate:Double!
    
    
}


class PubDetail{
    
    var publicationDate:String!
    var executionDate:String!
    var carTypes: String!
    var fromLat: Double!
    var toLat: Double!
    var fromLong: Double!
    var toLong: Double!

    var offerCount: Int!
    var Notes: String!
    
}
