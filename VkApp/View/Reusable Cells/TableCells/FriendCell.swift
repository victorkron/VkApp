//
//  FriendCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 23.12.2021.
//

import UIKit

final class FriendCell: UITableViewCell {
    
    @IBOutlet var friendName: UILabel!
    @IBOutlet var friendEmblem: UIImageView!
    
    func configure(
        emblem: UIImage,
        name: String) {
            self.friendName.text = name
            self.friendEmblem.image = emblem
        }
    
}
