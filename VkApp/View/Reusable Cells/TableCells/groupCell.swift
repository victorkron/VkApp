//
//  GroupCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 23.12.2021.
//

import UIKit

final class groupCell: UITableViewCell {
    @IBOutlet var groupEmblem: AvatarImage!
    @IBOutlet var groupName: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        super.touchesBegan(touches, with: event)
        
        if (touches.first?.view == groupEmblem.superview) {
            animateTapForImage()
        }
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let delay = 0.6
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    super.touchesEnded(touches, with: event)
        })

    }
    
    
    func configure(
        emblem: String,
        name: String) {
            self.groupName.text = name
            self.groupEmblem.downloaded(from: emblem)
        }
    
    func configure(
        image: UIImage?,
        name: String) {
            self.groupName.text = name
            self.groupEmblem.image = image
        }
    func configure(
        group: GroupViewModel
    ) {
        self.groupName.text = group.name
        self.groupEmblem.image = group.image
    }
    
    func animateTapForImage() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 10,
            options: [
                .curveEaseInOut,
                
            ],
            animations: {
                self.groupEmblem.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            },
            completion: { elem in
                UIView.animate(
                    withDuration: 1,
                    delay: 0,
                    usingSpringWithDamping: 0.2,
                    initialSpringVelocity: 10,
                    options: [
                        .curveEaseInOut,
                    ],
                    animations: {
                        self.groupEmblem.transform = CGAffineTransform(scaleX: 1, y: 1)
                    },
                    completion: { elem in
                        
                    })
            })
    }
}
