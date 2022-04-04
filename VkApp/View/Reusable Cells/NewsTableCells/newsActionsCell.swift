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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeButton.addTarget(
            self,
            action: #selector(likeButtonClciked),
            for: .touchUpInside)
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
    }
    
    
    func configure(isLiked: Bool = false, likes: Int, comments: Int, reposts: Int) {
        self.likeButtonPressed = isLiked
        likeCount.text = String(likes)
        commentCount.text = String(comments)
        sendCount.text = String(reposts)
    }
    
}
