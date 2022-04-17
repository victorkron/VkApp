//
//  TestVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 26.12.2021.
//

import Foundation
import UIKit

final class TestVC: UIViewController {
    
    var container: UIView! = UIView()
    
    private let width = 0
    private let height = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContainerPosition()
    }
    
    func setContainerPosition() {
        
        let duration = 5.0
    
        container.frame = CGRect(
            x: Int(self.view.bounds.midX) - width / 2,
            y: Int(self.view.bounds.midY) - height / 2,
            width: width,
            height: height)
        container.backgroundColor = .clear
        
        let shape = CAShapeLayer()
        let path = configPath()
        
        shape.path = path.cgPath
        shape.lineWidth = 3
        shape.strokeColor = UIColor.purple.cgColor
        shape.fillColor = UIColor(displayP3Red: 0.96, green: 0.85, blue: 0.99, alpha: 1).cgColor
        shape.strokeStart = 0.0
        shape.strokeEnd = 1.0
        
        
        let strokeStartAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeStart))
        strokeStartAnimation.fromValue = -0.1
        strokeStartAnimation.toValue = 0.9
        
        let strokeEndAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2
        animationGroup.repeatCount = .infinity
        animationGroup.animations = [
            strokeStartAnimation,
            strokeEndAnimation
        ]
        
        
        shape.add(animationGroup, forKey: nil)
        
        
        container.layer.addSublayer(shape)
        
        self.view.addSubview(container)
    }
    
    
    
    func configPath() -> UIBezierPath {
        let cloudPath = UIBezierPath()
        
        cloudPath.move(to: CGPoint(x: width / 2 - 20, y: height / 2))
        
        cloudPath.addCurve(
            to: CGPoint(x: width / 2 + 10 , y: height / 2  - 15),
            controlPoint1: CGPoint(x: width / 2 - 20, y: height / 2 - 20),
            controlPoint2: CGPoint(x: width / 2 + 0, y: height / 2 - 20))
        cloudPath.addCurve(
            to: CGPoint(x: width / 2 + 37 , y: height / 2  - 25),
            controlPoint1: CGPoint(x: width / 2 + 22, y: height / 2 - 40),
            controlPoint2: CGPoint(x: width / 2 + 35, y: height / 2 - 30))
        cloudPath.addCurve(
            to: CGPoint(x: width / 2 + 60 , y: height / 2  - 5),
            controlPoint1: CGPoint(x: width / 2 + 40, y: height / 2 - 40),
            controlPoint2: CGPoint(x: width / 2 + 65, y: height / 2 - 30))
        cloudPath.addCurve(
            to: CGPoint(x: width / 2 - 20 , y: height / 2),
            controlPoint1: CGPoint(x: width / 2 + 60, y: height / 2 + 20),
            controlPoint2: CGPoint(x: width / 2 - 20, y: height / 2 + 20))
        
        cloudPath.close()
        return cloudPath
    }
    
    
    

}


final class SomeRootView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(CGColor(red: 254, green: 0, blue: 0, alpha: 0.1))
        context.fill(CGRect(
            x: 0.0,
            y: 0.0,
            width: 100.0,
            height: 100.0))
    }
}

