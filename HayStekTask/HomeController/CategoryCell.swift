//
//  CategoryCell.swift
//  HayStekTask
//
//  Created by Geethansh  on 04/04/25.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var bgView:UIView!
    @IBOutlet weak var categoryImg:UIImageView!
    @IBOutlet weak var categoryLbl:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupData()
    }
    func setupData() {
        bgView.layer.cornerRadius = bgView.frame.height / 2
        bgView.layer.masksToBounds = true
        bgView.clipsToBounds = true
    }
}
