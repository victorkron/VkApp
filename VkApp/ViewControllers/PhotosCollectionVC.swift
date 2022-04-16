//
//  FriendsCollectionVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 17.12.2021.
//

import UIKit
import RealmSwift

class PhotosCollectionVC: UICollectionViewController {
    
    var firstname: String? = nil
    var lastname: String? = nil
    var id: Int = 0
    var avatar: String = ""
    private var photosToken: NotificationToken?
    private var networkService = Request<Albums>()
    var photos: Results<RealmPhotoCell>? = try? RealmService.load(typeOf: RealmPhotoCell.self)
    var photosBigSize: [String]? = []
    
    private var photoService: PhotoService?
    
    static var curretnIndex: Int? = nil
    static var fromFullScrenn: Bool? = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        photoService = PhotoService(container: collectionView)
        
        collectionView.register(registerClass: photoItem.self)
        collectionView.register(
            registerClass: someCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        DispatchQueue.global().async {
            self.getPhoto()
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
    
    private func getPhoto() {
        networkService.fetch(type: .photos, id: id) { [weak self] result in
            switch result {
            case .success(let photos):
                let items = photos.map { i -> RealmPhotoCell in
                    self?.photosBigSize?.append(i.sizes.last?.url ?? "")
                    let value = i.sizes.first { i in
                        i.type == "p"
                    }
                    let elem = RealmPhotoCell(photo: Photo(
                        height: value?.height ?? 0,
                        url: value?.url ?? "",
                        type: value?.type ?? ""))
                    return elem
                }
                DispatchQueue.main.async {
                    do {
                        try RealmService.save(items: items)
                        self?.photos = try RealmService.load(typeOf: RealmPhotoCell.self)
                    } catch {
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if PhotosCollectionVC.fromFullScrenn ?? false {
            let fullDuration = 0.7
            let a = collectionView.cellForItem(at: [0, PhotosCollectionVC.curretnIndex ?? 0]) as? photoItem
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
                            prob.layer.position.y = CGFloat(a?.layer.position.y ?? 0) - self.collectionView.contentOffset.y - 12 // magic constant
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
        super.viewDidAppear(animated)
        photosToken = photos?.observe { [weak self] photosChange in
            switch photosChange {
            case .initial, .update:
                self?.collectionView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        photosToken?.invalidate()
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PhotosCollectionVC.curretnIndex = indexPath.row
        onTap(currentIndex: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard
            let photos = photos
        else { return 0 }
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: photoItem = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        guard
            let url = self.photos?[indexPath.row].url
        else { return UICollectionViewCell() }
        cell.itemImage.backgroundColor = .gray
        let photo =  photoService?.photo(atIndexPath: indexPath, byUrl: url)
        cell.configure(image: photo)
        return cell
    }
    
    
    
    @objc
    func onTap(currentIndex: IndexPath) {
        let fullDuration = 0.7
        let a = collectionView.cellForItem(at: currentIndex) as? photoItem
        let mask = UIView()
        
        mask.frame = self.view.frame
        mask.backgroundColor =  .white
        mask.layer.opacity = 0
        
        let prob = UIImageView(image: a?.itemImage.image)
        prob.transform3D = CATransform3DMakeTranslation(0, 0, 1)
        prob.frame = a?.itemImage.frame ?? CGRect()
        prob.layer.position.x = a?.frame.midX ?? 0
        prob.layer.position.y = CGFloat(a?.layer.position.y ?? 0) - self.collectionView.contentOffset.y - 12
        
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
            let someHeader: someCollectionReusableView = collectionView.dequeueReusableCell(forIndexPath: indexPath, kind: kind)
                someHeader.configure(personLastname: self.lastname ?? "",
                                 personFirstname: self.firstname ?? "",
                                     personImage: self.avatar)
                return someHeader
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
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 150)
    }
    
  
}
