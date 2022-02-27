//
//  FriendCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 23.12.2021.
//

import UIKit


final class FriendCell: UITableViewCell {
    @IBOutlet var friendName: UILabel!
    @IBOutlet var friendEmblem: AvatarImage!
//    @IBInspectable var cornerRadius: CGFloat = 12.0 {
//        didSet {
//            setNeedsLayout()
//            layoutIfNeeded()
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        super.touchesBegan(touches, with: event)
        
        if (touches.first?.view == friendEmblem.superview) {
            animateTapForImage()
        }
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let delay = 0.2
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    super.touchesEnded(touches, with: event)
        })

    }
    
    func configure(
        emblem: String,
        name: String) {
            self.friendEmblem.downloaded(from: emblem)
            self.friendName.text = name
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
                self.friendEmblem.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            },
            completion: { elem in
                UIView.animate(
                    withDuration: 0.7,
                    delay: 0,
                    usingSpringWithDamping: 0.2,
                    initialSpringVelocity: 10,
                    options: [
                        .curveEaseInOut,
                    ],
                    animations: {
                        self.friendEmblem.transform = CGAffineTransform(scaleX: 1, y: 1)
                    },
                    completion: { elem in
                        
                    })
            })
    }
    
}
