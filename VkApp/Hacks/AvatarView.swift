//
//  AvatarImage.swift
//  VkApp
//
//  Created by Карим Руабхи on 27.12.2021.
//

import UIKit

class AvatarImage: UIImageView {
    /*@IBInspectable*/ var borderColor: UIColor = UIColor.brandGreen
    /*@IBInspectable*/ var borderWidth: CGFloat = 1.5
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
}


class AvatarBackShadow: UIView {
    /*@IBInspectable*/ var shadowColor: UIColor = UIColor.brandGray
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: -3)
    @IBInspectable var shadowOpacity: Float = 0.8
    @IBInspectable var shadowRadius: CGFloat = 3
    
    override func awakeFromNib() {
        self.backgroundColor = .clear
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
    }
    
}

