//
//  File.swift
//  HayStekTask
//
//  Created by Geethansh  on 04/04/25.
//

import UIKit

extension UIImageView {
    
    func addBadge(value: String?, textColor: UIColor = .white, backgroundColor: UIColor = .black) {
        let badgeLabel = UILabel()
        badgeLabel.text = value
        badgeLabel.textColor = textColor
        badgeLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        badgeLabel.textAlignment = .center
        badgeLabel.backgroundColor = backgroundColor
        badgeLabel.sizeToFit()
        badgeLabel.layer.cornerRadius = 11
        badgeLabel.clipsToBounds = true
        let badgeWidth: CGFloat = 22
        let badgeHeight: CGFloat = 22
        badgeLabel.frame.origin = CGPoint(x: self.frame.width - badgeWidth / 2 - 75, y: -badgeHeight / 2 + 3)
        badgeLabel.frame.size = CGSize(width: badgeWidth, height: badgeHeight)
        
        self.addSubview(badgeLabel)
    }
    
    func removeBadge() {
        self.subviews.forEach {
            if $0 is UILabel {
                $0.removeFromSuperview()
            }
        }
    }
}
