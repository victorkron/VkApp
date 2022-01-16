//
//  newsActionsCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 16.01.2022.
//

import UIKit

class newsActionsCell: UITableViewCell {

    @IBOutlet var likeButton: UIButton!
    @IBOutlet var likeCount: UILabel!
    private var likeButtonPressed: Bool = false
    
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var commentCount: UILabel!
    
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var sendCount: UILabel!
    
    @IBOutlet var viewsCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeButton.addTarget(
            self,
            action: #selector(likeButtonClciked),
            for: .touchUpInside)
        // Initialization code
    }
    
    
    @objc func likeButtonClciked(_ sender: UIButton) {
        likeButtonPressed = !likeButtonPressed
        if likeButtonPressed {
            likeButton.setImage(
                UIImage(systemName: "heart.fill"),
                for: .normal)
            likeCount.text = "\(Int(likeCount.text!)! + 1)"
            
            likeButton.tintColor = UIColor.red
            likeCount.textColor = UIColor.red
        } else {
            likeButton.setImage(
                UIImage(systemName: "heart"),
                for: .normal)
            likeCount.text = "\(Int(likeCount.text!)! - 1)"
            
            likeButton.tintColor = UIColor.tintColor
            likeCount.textColor = UIColor.black
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ data: ActionsData) {
        likeCount.text = String(data.likes!)
        commentCount.text = String(data.comments!)
        sendCount.text = String(data.sends!)
        viewsCount.text = String(data.views!)
    }
    
}
