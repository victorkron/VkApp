//
//  newsImageCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 02.04.2022.
//

import UIKit

class newsImageCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    @IBOutlet var imageCell: UIImageView!
    
    func configure(url: String) {
        self.imageCell.isHidden = true
        self.imageCell.backgroundColor = .gray
        self.imageCell.downloaded(from: url, contentMode: .scaleAspectFill)
        self.imageCell.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.image = nil
    }

}