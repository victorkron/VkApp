//
//  DescriptionCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 15.01.2022.
//

import UIKit

protocol ShowMoreDelegate: AnyObject {
    func updateTextHeight(indexPath: IndexPath)
}

class DescriptionCell: UITableViewCell {

    @IBOutlet var buttonShowText: UIButton!
    @IBOutlet var myDescription: UILabel!
    private var test: Int?
    private var isPressed = true
    private var nextValue: Bool = true
    var indexPath: IndexPath = IndexPath()
    weak var delegate: ShowMoreDelegate?
    
    @IBAction func buttonPressed(_ sender: Any) {
        if isPressed {
            myDescription.numberOfLines = 0
            buttonShowText.setTitle(
                "Свернуть",
                for: .normal
            )
            isPressed.toggle()
        } else {
            myDescription.numberOfLines = 4
            buttonShowText.setTitle(
                "Показать больше",
                for: .normal
            )
            isPressed.toggle()
        }
        delegate?.updateTextHeight(indexPath: indexPath)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ text: String) {
        myDescription.text = text
        if text.count > 150 {
            buttonShowText.isHidden = false
        } else {
            buttonShowText.isHidden = true
        }
    }
}
