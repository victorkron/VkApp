//
//  AvatarCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 15.01.2022.
//

import UIKit
import SwiftUI

class AvatarCell: UITableViewCell {
    
    @IBOutlet var avatar: AvatarImage!
    @IBOutlet var name: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBAction func buttonHasPressed(_ sender: Any) {
        print("Hello")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ image: String, _ name: String, _ date: String) {
        self.avatar.frame.size = CGSize(width: 50, height: 50)
        self.avatar.image = nil
        self.avatar.downloaded(from: image)
        self.name.text = name
        self.dateLabel.text = date
    }
    
}
