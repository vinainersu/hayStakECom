//
//  LocationCell.swift
//  HayStekTask
//
//  Created by Geethansh  on 04/04/25.
//

import UIKit

class LocationCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView! {
        didSet {
            bgView.layer.cornerRadius = 25
            bgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            bgView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bgSelectView: UIView! {
        didSet {
            bgSelectView.layer.cornerRadius = 25
            bgSelectView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bgSelectView.clipsToBounds = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    
}
