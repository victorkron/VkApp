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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print(photos)
        return photos!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "photoItem",
            for: indexPath)
                as? PhotoItem
        else { return UICollectionViewCell() }
            
        cell.configure(image: UIImage(named: "Collections/\(personName)/caption\(indexPath.row + 1)") ?? UIImage())
        return cell
        
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

    
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

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
