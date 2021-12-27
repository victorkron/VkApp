//
//  GroupCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 23.12.2021.
//

import UIKit

final class GroupCell: UITableViewCell {
    @IBOutlet var groupEmblem: AvatarImage!
    @IBOutlet var groupName: UILabel!
    
        func configure(
        emblem: UIImage,
        name: String) {
            self.groupName.text = name
            self.groupEmblem.image = emblem
        }
}
