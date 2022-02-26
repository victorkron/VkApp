//
//  FriendsCollectionVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 17.12.2021.
//

import UIKit

class PhotosCollectionVC: UICollectionViewController {
    
    var firstname: String? = nil
    var lastname: String? = nil
    var id: Int = 0
    var avatar: String = ""
    var photos: [String]? = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var photosBigSize: [String]? = []
    
    
    static var curretnIndex: Int? = nil
    static var fromFullScrenn: Bool? = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(
            PhotoItem.self,
            forCellWithReuseIdentifier: "photoItem")
        self.collectionView.register(
            UINib(nibName: "PhotoItem",
                  bundle: nil),
            forCellWithReuseIdentifier: "photoItem")
        self.collectionView.register(
            UINib(nibName: "SomeCollectionReusableView",
                  bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "someCollectionReusableView")
        let request = Request()
        request.getPhotos(id: String(id)) { [weak self] result in
            switch result {
            case .success(let photos):
                photos.items.forEach { i in
                    self?.photos?.append(i.sizes.first?.url ?? "")
                    self?.photosBigSize?.append(i.sizes.last?.url ?? "")
                }
            case .failure(let error):
                print(error)
            }
            
        }
        
        
    }
    
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "photoFullScreen"
        else { return }
        
        guard
            let destination = segue.destination as? PhotoFullScrennVC
        else { return }
        
        destination.photos = self.photosBigSize ?? []
        destination.currentIndex = PhotosCollectionVC.curretnIndex
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if PhotosCollectionVC.fromFullScrenn ?? false {
            print(self.collectionView.scrollIndicatorInsets.bottom)
            let fullDuration = 0.7
            let a = collectionView.cellForItem(at: [0, PhotosCollectionVC.curretnIndex ?? 0]) as? PhotoItem
//            let a = collectionView.visibleCells[PhotosCollectionVC.curretnIndex ?? 0]
            let k = self.view.frame.width / (a?.frame.width ?? self.view.frame.width)
            
            let mask = UIView()
            let prob = UIImageView(image: a?.itemImage.image)
            
            mask.frame = self.view.frame
            mask.backgroundColor =  .white
            mask.layer.opacity = 1
            
            prob.transform3D = CATransform3DMakeTranslation(0, 0, 1)
            prob.frame = a?.itemImage.frame ?? CGRect()
            prob.layer.position = CGPoint(
                x: self.view.frame.width / 2,
                y: self.view.frame.height / 2 + 3)
            
            
            let scale = CGAffineTransform(
                scaleX: k,
                y: k)
            
            prob.transform = scale
            
            
            self.view.addSubview(mask)
            self.view.addSubview(prob)
            
            
            UIView.animateKeyframes(
                withDuration: fullDuration,
                delay: 0.0,
                options: [
                    .calculationModePaced
                ],
                animations: {
                    
                    UIView.addKeyframe(
                        withRelativeStartTime: 0.0,
                        relativeDuration: 1.0,
                        animations: {
                            prob.layer.position.x = a?.frame.midX ?? 0
                            prob.layer.position.y = CGFloat(a?.layer.position.y ?? 0)  + CGFloat(a?.frame.height ?? 0) - CGFloat(a?.itemImage.frame.height ?? 0) + prob.frame.size.height / 6.4  - self.collectionView.contentOffset.y// magic constant
                        })
                    
                    UIView.addKeyframe(
                        withRelativeStartTime: 0.0,
                        relativeDuration: 1.0,
                        animations: {
                            prob.transform = .identity
                        })
                    
                    UIView.addKeyframe(
                        withRelativeStartTime: 0.0,
                        relativeDuration: 1.0,
                        animations: {
                            mask.layer.opacity = 0
                        })
                },
                completion: { i in
                    
                    prob.removeFromSuperview()
                    mask.removeFromSuperview()
                    PhotosCollectionVC.fromFullScrenn = false
                })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    // MARK: UICollectionViewDataSource
    

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PhotosCollectionVC.curretnIndex = indexPath.row
        onTap(currentIndex: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "photoItem",
            for: indexPath)
                as? PhotoItem
        else { return UICollectionViewCell() }
            
        cell.configure(image: photos?[indexPath.row] ?? "")
        return cell
        
    }
    
    
    
    @objc
    func onTap(currentIndex: IndexPath) {
        let fullDuration = 0.7
        let a = collectionView.cellForItem(at: currentIndex) as? PhotoItem
        let mask = UIView()
        
        mask.frame = self.view.frame
        mask.backgroundColor =  .white
        mask.layer.opacity = 0
        
        let prob = UIImageView(image: a?.itemImage.image)
        prob.transform3D = CATransform3DMakeTranslation(0, 0, 1)
        prob.frame = a?.itemImage.frame ?? CGRect()
        prob.layer.position.x = a?.frame.midX ?? 0
        prob.layer.position.y = CGFloat(a?.layer.position.y ?? 0)  + CGFloat(a?.frame.height ?? 0) - CGFloat(a?.itemImage.frame.height ?? 0) + prob.frame.size.height / 2
        
        let k = self.view.frame.width / prob.frame.width
        
        self.view.addSubview(prob)
        self.view.addSubview(mask)
    
        
        
        
        UIView.animateKeyframes(
            withDuration: fullDuration,
            delay: 0.0,
            options: [
                .calculationModePaced
            ],
            animations: {

                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 1.0,
                    animations: {
                        prob.layer.position = CGPoint(
                            x: prob.layer.frame.width * k / 2,
                            y: self.view.frame.height / 2)
                    })
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 1.0,
                    animations: {
                        let scale = CGAffineTransform(
                            scaleX: k,
                            y: k)
                        prob.transform = scale
                    })
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 1.0,
                    animations: {
                        mask.layer.opacity = 1
                    })

                
            },
            completion: { i in
                self.performSegue(withIdentifier: "photoFullScreen", sender: nil)
                
                prob.removeFromSuperview()
                mask.removeFromSuperview()
            })
        
        
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard
                    let someHeader = collectionView.dequeueReusableSupplementaryView(
                                    ofKind: kind,
                                    withReuseIdentifier: "someCollectionReusableView",
                                    for: indexPath)
                        as? SomeCollectionReusableView
                else { return UICollectionReusableView() }
                someHeader.configure(personLastname: self.lastname ?? "",
                                 personFirstname: self.firstname ?? "",
                                     personImage: self.avatar)
                return someHeader
            //          case UICollectionView.elementKindSectionFooter:
//
            default:
                return UICollectionReusableView()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("began")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("move")
    }

}


extension PhotosCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
//        layout.headerReferenceSize = CGSize(width: width, height: 120)
//        layout.sectionHeadersPinToVisibleBounds = true
        
        return CGSize(width: width, height: 150)
    }
    
  
}
