//
//  FriendsCollectionVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 17.12.2021.
//

import UIKit

class PhotosCollectionVC: UICollectionViewController {
    
    
    var personName: String = " "
    var firstname: String? = nil
    var lastname: String? = nil
    var personAge: UInt? = 10
    var photos: [String]? = ["caption1"]
    var curretnIndex: Int? = nil

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
        print(UICollectionView.elementKindSectionHeader)
    }
    
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "photoFullScreen"
        else { return }
        
        guard
            let destination = segue.destination as? PhotoFullScrennVC
        else { return }
        
        destination.photos = self.photos!
        destination.currentIndex = self.curretnIndex
        destination.personName = self.personName
    }
    
    
    // MARK: UICollectionViewDataSource
    

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.curretnIndex = indexPath.row
        onTap()
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
            
        cell.configure(image: UIImage(named: "Collections/\(personName)/caption\(indexPath.row + 1)") ?? UIImage())
        
//        cell.imageView.self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
        
        return cell
        
    }
    
    
    
    @objc
    func onTap() {
        performSegue(withIdentifier: "photoFullScreen", sender: nil)
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
                                 personImage: UIImage(named: "Friends/\(personName)") ?? UIImage())
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
        print("end")
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
