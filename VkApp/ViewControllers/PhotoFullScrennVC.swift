//
//  PhotoFullScrennVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 21.01.2022.
//

import UIKit


class PhotoFullScrennVC: UIViewController {
    
    var photos: [String] = ["caption1"]
    var currentIndex: Int? = nil
//    var personName: String = " "
    let duration: CGFloat = 0.5
    private var propertyAnimatorToTheRight: UIViewPropertyAnimator!
    private var propertyAnimatorToTheLeft: UIViewPropertyAnimator!

    @IBOutlet var Container: UIView!
    @IBOutlet var imageView: UIImageView!
    var leftImageView: UIImageView!
    var rightImageView: UIImageView!
    
    func checkIndex(Index: Int, previous: inout Int, next: inout Int) {
        if ((Index - 1) < 0) {
            previous = (photos.count) - 1
            next = Index + 1
        } else if ((Index + 1) > photos.count - 1) {
            previous = Index - 1
            next = 0
        } else {
            previous = Index - 1
            next = Index + 1
        }
    }
    
    func setCurrentIndex(myIndex: inout Int, nextValue: Int) {
        if (nextValue < 0) {
            myIndex = (photos.count) - 1
        } else if (nextValue > photos.count - 1) {
            myIndex = 0
        } else {
            myIndex = nextValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setImage(currentIndex)
        
        let paner = UIPanGestureRecognizer(
            target: self,
            action: #selector(didPan(_:)))
        
        let swiper = UISwipeGestureRecognizer(
            target: self,
            action: #selector(didSwipe(_:))
        )
        swiper.direction = .down
        swiper.delegate = self
        
        imageView.addGestureRecognizer(swiper)
        imageView.addGestureRecognizer(paner)
        
    }
    
    @objc
    func didSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .down:
            navigationController?.popViewController(animated: false)
        default:
            print("Other")
        }
    }
    
    @objc
    func didPan(_ gesture: UIPanGestureRecognizer) {
        let scaleForSideImage = 0.7
        let leftImageViewWidth = Container.bounds.width * scaleForSideImage
        let leftImageViewHeight = 1000
        
        let rightImageViewWidth = Container.bounds.width * scaleForSideImage
        let rightImageViewHeight = 1000
        
        
        
        
        
        switch gesture.state {
        case .began:
            
            
            
            var previousIndex: Int = 0
            var nextIndex: Int = 0
            
            checkIndex(Index: currentIndex!, previous: &previousIndex, next: &nextIndex)
            
            let leftName: String = Optional(photos[previousIndex]) ?? photos[0]
            let rightName: String = Optional(photos[nextIndex]) ?? photos[0]// index out of range if photos.count<2
            
            leftImageView = UIImageView(frame: CGRect(
                x: -Int(self.Container.bounds.width) + Int(self.Container.bounds.width - leftImageViewWidth) / 2,
                y: Int(self.Container.bounds.midY) - Int(leftImageViewHeight / 2),
                width: Int(leftImageViewWidth),
                height: leftImageViewHeight))//leftImage?.size.height ?? Container.bounds.height))
            leftImageView.downloaded(from: leftName)
            
            rightImageView = UIImageView(frame: CGRect(
                x: self.Container.bounds.width + (self.Container.bounds.width - rightImageViewWidth) / 2,
                y: self.Container.bounds.midY - CGFloat(rightImageViewHeight) / 2.0,
                width: rightImageViewWidth,
                height: CGFloat(rightImageViewHeight)))
            rightImageView.downloaded(from: rightName)
            
            Container.addSubview(leftImageView)
            Container.addSubview(rightImageView)
            
            
            
            // прокрутка вправо
            propertyAnimatorToTheRight = UIViewPropertyAnimator(
                duration: duration,
                curve: .linear,
                animations: {
                    // центральный
                    self.scalingMainView(self.imageView, 0.3)
                    self.assignTransformImageForOneWithScale(
                        neededImageView: self.leftImageView,
                        self.Container.bounds.width - CGFloat(Int(self.Container.bounds.width - leftImageViewWidth)),
                        1 / scaleForSideImage,
                        1 / scaleForSideImage)
                 
                })
            
            
            // прокрутка влево
            propertyAnimatorToTheLeft = UIViewPropertyAnimator(
                duration: duration,
                curve: .easeInOut,
                animations: {
                    // центральный
                    self.scalingMainView(self.imageView, 0.09) // 0.09 that's why the previous setting scalingMainView have impact on this item (0.3 * 0.3 = 0.09)
                    self.assignTransformImageForOneWithScale(
                        neededImageView: self.rightImageView,
                        -self.Container.bounds.width + (self.Container.bounds.width - rightImageViewWidth),
                        1 / scaleForSideImage,
                        1 / scaleForSideImage)
                })
            
            propertyAnimatorToTheRight.pauseAnimation()
            propertyAnimatorToTheLeft.pauseAnimation()
            
        case .changed:
            
            let translation = gesture.translation(in: self.imageView)
            propertyAnimatorToTheRight.fractionComplete = translation.x / 1000
            propertyAnimatorToTheLeft.fractionComplete = -translation.x / 1000
            
        case .ended:
            let progressleft = propertyAnimatorToTheLeft.fractionComplete
            let progressRight = propertyAnimatorToTheRight.fractionComplete
            propertyAnimatorToTheRight.stopAnimation(true)
            propertyAnimatorToTheLeft.stopAnimation(true)
        
            if (progressleft > 0.5) {
                animateScrollImage(-self.Container.bounds.width, 0.5, xScale: 0.3, yScale: 0.3)
                animateScale(
                    myImageView: rightImageView,
                    (-self.Container.bounds.width) + (self.Container.bounds.width - rightImageViewWidth),
                    1 / scaleForSideImage,
                    1 / scaleForSideImage,
                    duration: 0.5)
              
                
                setCurrentIndex(myIndex: &currentIndex!, nextValue: currentIndex! + 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.setImageForAll(
                        left: self.leftImageView,
                        center: self.imageView,
                        right: self.rightImageView,
                        index: self.currentIndex!,
                        xScale: 0.3,
                        yScale: 0.3)
                    self.rightImageView.image = nil
                    self.leftImageView.image = nil
                })
            } else if (progressRight > 0.5) {
                animateScrollImage(self.Container.bounds.width, 0.5, xScale: 0.3, yScale: 0.3)
                animateScale(
                    myImageView: leftImageView,
                    self.Container.bounds.width - CGFloat(Int(self.Container.bounds.width - leftImageViewWidth)),
                    1 / scaleForSideImage,
                    1 / scaleForSideImage,
                    duration: 0.5)
               
                
                setCurrentIndex(myIndex: &currentIndex!, nextValue: currentIndex! - 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.setImageForAll(
                        left: self.leftImageView,
                        center: self.imageView,
                        right: self.rightImageView,
                        index: self.currentIndex!,
                        xScale: 0.3,
                        yScale: 0.3)
                    self.rightImageView.image = nil
                    self.leftImageView.image = nil
                })
            } else {
                animateScrollImage(0, 0.5, xScale: 0.3, yScale: 0.3)
                animateScale(
                    myImageView: leftImageView,
                    0 - CGFloat(Int(self.Container.bounds.width - leftImageViewWidth)),
                    1 ,
                    1 ,
                    duration: 0.5)
                animateScale(
                    myImageView: rightImageView,
                    0 + (self.Container.bounds.width - rightImageViewWidth),
                    1 ,
                    1 ,
                    duration: 0.5)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.rightImageView.image = nil
                    self.leftImageView.image = nil
                })
                
            }
            
        default:
            return
            
        }
        
    }
    
    
    
    
    
    
    
    func scalingMainView(_ imageV: UIImageView, _ scalingParam: Double) {
        let scaleTransform = CGAffineTransform(
            scaleX: scalingParam,
            y: scalingParam)
        
        imageV.transform = scaleTransform//transform.concatenating(scaleTransform)
    }
    
    func setImage(_ index: Int?) {
        let name: String = photos[self.currentIndex!]
        imageView.downloaded(from: name)
    }
    
    func setImageForAll(left: UIImageView, center: UIImageView, right: UIImageView, index: Int, xScale: CGFloat, yScale: CGFloat) {
        let name: String = photos[self.currentIndex!]
        center.downloaded(from: name)
        self.animateScrollImage(0, 0, xScale: xScale, yScale: yScale)
        assignTransformImageForOne(neededImageView: rightImageView, Container.bounds.width)
        assignTransformImageForOne(neededImageView: leftImageView, -Container.bounds.width)
        
        
        var previous = 0
        var next = 0
        
        checkIndex(Index: currentIndex!, previous: &previous, next: &next)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            let leftName: String = self.photos[previous]
            let rightName: String = self.photos[next]
            left.downloaded(from: leftName)
            right.downloaded(from: rightName)
        })
        
    }
    
    
    func assignTransformImageForOne(neededImageView: UIImageView, _ x: CGFloat) {
        let transform = CGAffineTransform(
            translationX: x,
            y: Container.bounds.minY)
        neededImageView.transform = transform
    }

    func assignTransformImageForOneWithScale(neededImageView: UIImageView, _ x: CGFloat, _ scaleX: CGFloat, _ scaleY: CGFloat) {
        let transform = CGAffineTransform(
            translationX: x,
            y: Container.bounds.minY)
        let scaleTransform = CGAffineTransform(
            scaleX: scaleX,
            y: scaleY)
        
        neededImageView.transform = transform.concatenating(scaleTransform)
    }
    
    
    func animateScale(myImageView: UIImageView, _ x: CGFloat, _ scaleX: CGFloat, _ scaleY: CGFloat, duration: CGFloat) {
        UIView.animate(
            withDuration: duration,
            animations: {
                let transform = CGAffineTransform(
                    translationX: x,
                    y: self.Container.bounds.minY)
                let transformScale = CGAffineTransform(
                    scaleX: scaleX,
                    y: scaleY)
                myImageView.transform = transform.concatenating(transformScale)
            })
    }
    
    func animateScrollImage(_ x: CGFloat, _ duration: CGFloat, xScale: CGFloat, yScale: CGFloat) {
        if x == 0 {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: [
                    
                ],
                animations: {
                    self.imageView.transform = .identity
                },
                completion: { _ in
                    
                })
        } else {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: [
                    
                ],
                animations: {
                    let transform = CGAffineTransform(
                        scaleX: xScale,
                        y: yScale)
                    self.imageView.transform = transform
                },
                completion: { _ in
                    
                })
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if (storyboard?.instantiateViewController(withIdentifier: "personCollection") as? PhotosCollectionVC) != nil {
            PhotosCollectionVC.fromFullScrenn = true
            PhotosCollectionVC.curretnIndex = self.currentIndex
        }
    }

}


extension PhotoFullScrennVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
