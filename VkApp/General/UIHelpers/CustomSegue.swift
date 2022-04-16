//
//  CustomSegue.swift
//  VkApp
//
//  Created by Карим Руабхи on 31.01.2022.
//

import UIKit

final class CustomSegue: UIStoryboardSegue {
    private let animationTime = 3.5
     
    
    override func perform() {
        guard let conteinerView = source.view else { return }
        
        
        conteinerView.addSubview(destination.view)
        
        destination.view.frame = conteinerView.frame
        
        destination.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animateKeyframes(
            withDuration: animationTime,
            delay: 0,
            options: [
                .calculationModePaced
            ],
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 0.2,
                    animations: {
                        let rotatation = CATransform3DMakeRotation(.pi/2, 0, 1, 0)
                        let scaling = CATransform3DMakeScale(0.8, 0.8, 0.8)
                        self.source.view.transform3D = CATransform3DConcat(rotatation, scaling)
                    })
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0.2,
                    relativeDuration: 0.15,
                    animations: {
                        self.source.view.transform3D = CATransform3DMakeRotation(.pi/2, 1, 1, 0)
                    })
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0.35,
                    relativeDuration: 0.15,
                    animations: {
                        self.source.view.transform3D = CATransform3DMakeRotation(.pi, 1, 1, 1)
                    })
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0.5,
                    relativeDuration: 0.2,
                    animations: {
                        self.destination.view.transform = .identity
                    })
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0.7,
                    relativeDuration: 0.3,
                    animations: {
                        self.source.view.transform3D = CATransform3DMakeRotation(0, 0, 1, 0)
                    })
            },
            completion: { _ in
                self.source.present(
                    self.destination,
                    animated: false,
                    completion: nil)
            })
        
        
    }
    
    
}
