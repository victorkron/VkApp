//
//  DescriptionCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 15.01.2022.
//

import UIKit

class DescriptionCell: UITableViewCell {

    
    @IBOutlet var myDescription: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ text: String) {
        myDescription.text = text
//        self.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 80)  // не работает(
    }
}
