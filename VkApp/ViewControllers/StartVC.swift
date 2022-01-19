//
//  LaunchVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 19.01.2022.
//

import UIKit

class StartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(someView)
        configLoadBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sleep(3)
        goToNextPage()
    }
    
    private func goToNextPage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController
        nextViewController?.modalPresentationStyle = .fullScreen
        self.present(nextViewController ?? UIViewController(), animated: true, completion: nil)
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
//        container.backgroundColor = .gray.withAlphaComponent(0.7)
        
        
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
        
        
        
//
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
