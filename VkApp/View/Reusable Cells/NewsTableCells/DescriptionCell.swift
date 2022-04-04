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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ text: String) {
        myDescription.text = text
    }
}
