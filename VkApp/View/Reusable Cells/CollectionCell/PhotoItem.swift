//
//  PhotoItem.swift
//  VkApp
//
//  Created by Карим Руабхи on 02.01.2022.
//

import UIKit

final class PhotoItem: UICollectionViewCell {
//
//    @IBInspectable var imageWidth: CGFloat = 100 {
//        didSet {
//            setNeedsLayout()
//            layoutIfNeeded()
//        }
//    }
    private var pressed: Bool = false
    private var amountOfLike: Int = 0

    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var imageView: UIView!
    
    @IBOutlet var button: UIButton!
    @IBOutlet var likes: UILabel!
    
    @IBAction func didLikePressed(_ sender: Any) {
        pressed = !pressed
        if pressed {
            amountOfLike = amountOfLike + 1
            button.setImage(
                UIImage(systemName: "heart.fill"),
                for: .normal)
            likes.text = "\(amountOfLike)"
            
            button.tintColor = UIColor.red
            likes.textColor = UIColor.red
        } else {
            amountOfLike = amountOfLike - 1
            button.setImage(
                UIImage(systemName: "heart"),
                for: .normal)
            likes.text = "\(amountOfLike)"
            
            button.tintColor = UIColor.tintColor
            likes.textColor = UIColor.black
        }
    }
    
    func configure(image: UIImage?) {
        self.itemImage.image = image
        likes.text = "\(amountOfLike)"
    }

}
