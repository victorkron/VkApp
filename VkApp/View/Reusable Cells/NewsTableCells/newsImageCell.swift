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
        self.imageCell.image = nil
        self.imageCell.downloaded(from: url)
        self.imageCell.contentMode = .scaleAspectFit
        self.imageCell.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.image = nil
    }

}
