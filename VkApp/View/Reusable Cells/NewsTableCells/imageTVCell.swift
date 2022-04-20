//
//  imageTVCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 20.04.2022.
//

import UIKit

class imageTVCell: UITableViewCell {
    
    static let identifier: String = "imageTVCell"

    private let newsImageView: UIImageView = {
        let newsImageView = UIImageView()
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        return newsImageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
        contentView.addSubview(newsImageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = nil
    }

    func configure(_ image: String) {
        newsImageView.downloaded(from: image)
    }

    private func setConstraints() {

        contentView.addSubview(newsImageView)

        let topConstraint = newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor)

        NSLayoutConstraint.activate([
            topConstraint,
            newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            newsImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            newsImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

        topConstraint.priority = .init(999)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        newsImageView.frame = contentView.bounds
    }
}

