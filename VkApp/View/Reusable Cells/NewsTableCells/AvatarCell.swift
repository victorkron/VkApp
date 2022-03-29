//
//  AvatarCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 15.01.2022.
//

import UIKit
import SwiftUI

class AvatarCell: UITableViewCell {
    
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBAction func buttonHasPressed(_ sender: Any) {
        print("Hello")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ image: UIImage?, _ name: String, _ date: String) {
        self.avatar.frame.size = CGSize(width: 50, height: 50)
        self.avatar.image = image
        self.name.text = name
        self.dateLabel.text = date
    }
    
}
