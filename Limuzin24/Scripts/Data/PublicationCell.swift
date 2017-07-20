//
//  PublicationCell.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 07.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation



import UIKit

class PubCell: UITableViewCell {
    
    @IBOutlet weak var inProcessLabel: UIButton!
        
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var Note: UILabel!
    @IBOutlet weak var carType: UILabel!
    var pubId:Int!
    var status:Int!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func createCell(pub: Publication){
        pubId = pub.pubId
        date.text = pub.date_of_publication
        Note.text = pub.notes
        carType.text = pub.carType
        status = pub.status
        if(status==1){
           inProcessLabel.isHidden = false
        }
        
    }

}
