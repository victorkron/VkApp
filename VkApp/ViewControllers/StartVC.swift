//
//  LaunchVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 19.01.2022.
//

import UIKit

class StartVC: UIViewController {

    let width = 0
    let height = 0
    let duration = 3.0
    
    var container: UIView! = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sleep(UInt32(duration)) // задержка для показа анимации
        goToNextPage()
    }
    
    private func goToNextPage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController
        nextViewController?.modalPresentationStyle = .fullScreen
        self.present(nextViewController ?? UIViewController(), animated: true, completion: nil)
    }
    
    func setAnimation() {
        
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
        shape.fillColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.00, alpha: 1).cgColor
        shape.strokeStart = 0.0
        shape.strokeEnd = 1.0
        
        
        
        let strokeStartAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeStart))
        strokeStartAnimation.fromValue = -0.1
        strokeStartAnimation.toValue = 0.9
        
        let strokeEndAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.repeatCount = 1 //.infinity
        animationGroup.animations = [
//            strokeStartAnimation,
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
        
//        cloudPath.move(to: CGPoint(x: width / 2 - 20, y: height / 2))
        
        cloudPath.close()
        return cloudPath
    }
    
    
    private func configLoadBar() {
        let distanceBetweenCentersOfCircles: CGFloat = 25
        let circleWidth: CGFloat = 15
        let container = UIView(frame: CGRect(
            x: view.frame.minX,
            y: view.frame.minY,
            width: view.frame.width,
            height: view.frame.height))
        view.addSubview(container)
        
        for i in 0...2 {
            let circle = UIView(frame: CGRect(
                x: container.bounds.midX + distanceBetweenCentersOfCircles * (CGFloat(i) - 1),
                y: container.bounds.midY,
                width: circleWidth,
                height: circleWidth))
            circle.backgroundColor = .black
            circle.self.alpha = 0
            
            
            UIView.animate(
                withDuration: 0.7,
                delay: CGFloat(i) / 3,
                options: [
                    .curveEaseInOut,
                    .repeat,
                    .autoreverse
                ],
                animations: {
                    circle.self.alpha = 1
                },
                completion: { i in
                    
                })
            circle.layer.cornerRadius = circleWidth / 2
            container.addSubview(circle)
        }
        
    }


}
