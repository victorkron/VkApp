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
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        setConstraints()
        self.imageCell.isHidden = true
        self.imageCell.backgroundColor = .gray
        self.imageCell.downloaded(from: url, contentMode: .scaleAspectFill)
        self.imageCell.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.image = nil
    }

    private func setConstraints() {
        let topConstraint = imageCell.topAnchor.constraint(equalTo: contentView.topAnchor)

        NSLayoutConstraint.activate([
            topConstraint,
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageCell.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageCell.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

        topConstraint.priority = .init(999)
    }
}
