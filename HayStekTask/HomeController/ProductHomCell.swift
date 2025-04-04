//
//  ProductHomCell.swift
//  HayStekTask
//
//  Created by Geethansh  on 04/04/25.
//

import UIKit
import SDWebImage

protocol AddToCart: AnyObject {
    func onTapHeart(index: Int)
}

class ProductHomCell: UICollectionViewCell {
    @IBOutlet weak var bgView:UIView!
    @IBOutlet weak var productImg:UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var amountLbl:UILabel!
    @IBOutlet weak var oldAmountLbl:UILabel!
    @IBOutlet weak var heartImg:UIImageView!
    @IBOutlet weak var heratBtn:UIButton!
    @IBOutlet weak var heartView: UIView! {
        didSet {
            heartView.layer.cornerRadius = heartView.frame.height / 2
        }
    }
    var delegate: AddToCart?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 15
        bgView.layer.masksToBounds = true
        bgView.clipsToBounds = true
    }
    
    func setData(model: ProductsModel) {
        productImg.sd_setImage(with: URL(string: model.image ?? ""))
        amountLbl.text =  "₹ \(model.price ?? 0)"
        oldAmountLbl.text =  "₹ \(model.price ?? 0)"
        nameLbl.text = model.title
        if model.isAddedToCart == true {
            heartImg.image = UIImage(systemName: "heart.fill")
            heartImg.tintColor = UIColor(named: "Green")
        } else {
            heartImg.image = UIImage(systemName: "heart")
            heartImg.tintColor = .black
        }
    }
    
    @IBAction func onTapHeartBtn() {
        delegate?.onTapHeart(index: heratBtn.tag)
    }
}
