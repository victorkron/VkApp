//
//  FriendCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 23.12.2021.
//

import UIKit


final class FriendCell: UITableViewCell {
    @IBOutlet var friendName: UILabel!
    @IBOutlet var friendEmblem: AvatarImage!
//    @IBInspectable var cornerRadius: CGFloat = 12.0 {
//        didSet {
//            setNeedsLayout()
//            layoutIfNeeded()
//        }
//    }
    
    
    func configure(
        emblem: UIImage,
        name: String) {
            self.friendName.text = name
            self.friendEmblem.image = emblem
        }
    
}
