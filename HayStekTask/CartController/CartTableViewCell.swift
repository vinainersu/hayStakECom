//
//  CartTableViewCell.swift
//  HayStekTask
//
//  Created by Geethansh  on 04/04/25.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
    }

    func setData(model: ProductsModel) {
        img.sd_setImage(with: URL(string: model.image ?? ""))
        nameLbl.text = model.title
        priceLbl.text = "₹ \(model.price ?? 0)"
    }
    
}
