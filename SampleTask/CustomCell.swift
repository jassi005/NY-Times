//
//  CustomCell.swift
//  SampleTask
//
//  Created by bhupendra on 13/11/18.
//  Copyright © 2018 bhupendra. All rights reserved.
//

import UIKit



class CustomCell: UITableViewCell {

     @IBOutlet weak var ImgName = UIImageView()
    
     @IBOutlet weak var ImgUSerProfile = UIImageView()
    
     @IBOutlet weak var lblDesc = UILabel()
     @IBOutlet weak var lblDate = UILabel()
     @IBOutlet weak var lblTitle = UILabel()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ImgName?.layer.masksToBounds = false
        ImgName?.layer.cornerRadius = (ImgName?.frame.height)!/2
        ImgName?.clipsToBounds = true
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
