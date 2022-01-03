//
//  PhotoCollectionCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 23.12.2021.
//

import UIKit

final class PhotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet var photoImage: UIImageView!
    @IBOutlet var personName: UILabel!
    @IBOutlet var personAge: UILabel!
    
    func configure(
        image: UIImage?, name: String, age: UInt) {
            self.photoImage.image = image
            self.personName.text = name
            self.personAge.text = "\(String(age))"
    }
}

