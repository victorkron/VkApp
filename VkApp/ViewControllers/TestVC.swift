//
//  TestVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 26.12.2021.
//

import Foundation
import UIKit

final class TestVC: UIViewController {
    
//    @IBOutlet var someButton: UIButton!
//    
//    private var count = 0
//    
//    @IBAction func didPressButton() {
//        count = count + 1
//        if (count % 2 == 0) {
//            someButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        } else {
//            someButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        }
//    }
//    
//    private let someView: UIView = SomeRootView()
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        view.addSubview(someView)
//        configView()
//    }
//    
//    private func configView() {
//        someButton.setImage(UIImage(systemName: "heart"), for: .normal)
//    }
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

