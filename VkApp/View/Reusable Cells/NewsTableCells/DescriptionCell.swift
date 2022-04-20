//
//  DescriptionCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 15.01.2022.
//

import UIKit

fileprivate var isPressed: Bool = false

class DescriptionCell: UITableViewCell {

    @IBOutlet var buttonShowText: UIButton!
    @IBOutlet var myDescription: UILabel!
//    private var isPressed: Bool = false
    private var source: UpdateTableView?
    private var indexPath: IndexPath?
    
    @IBAction func buttonPressed(_ sender: Any) {
        isPressed = !isPressed
        guard let index = indexPath else { return }
        if isPressed {
            source?.updateTV(index: index)
        } else {
            source?.updateTV(index: index)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ text: String, source: UpdateTableView, _ indexPath: IndexPath) {
        if isPressed {
            myDescription.numberOfLines = 1000
            buttonShowText.setTitle(
                "Свернуть",
                for: .normal
            )
        } else {
            myDescription.numberOfLines = 4
            buttonShowText.setTitle(
                "Показать больше",
                for: .normal
            )
        }
        
        self.source = source
        if text.count > 150 {
            buttonShowText.isHidden = false
        } else {
            buttonShowText.isHidden = true
        }
        myDescription.text = text
        self.indexPath = indexPath
    }
}
