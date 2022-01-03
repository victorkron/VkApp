//
//  FriendsCollectionVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 17.12.2021.
//

import UIKit

class PhotosCollectionVC: UICollectionViewController {
    
    var first: Bool = true
    var personName: String = " "
    var personAge: UInt? = 10
    var photos: [String]? = ["caption1"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(
            PhotoCollectionCell.self,
            forCellWithReuseIdentifier: "photoCollectionCell")
        self.collectionView.register(
            UINib(nibName: "PhotoCollectionCell",
                  bundle: nil),
            forCellWithReuseIdentifier: "photoCollectionCell")
        self.collectionView!.register(
            PhotoItem.self,
            forCellWithReuseIdentifier: "photoItem")
        self.collectionView.register(
            UINib(nibName: "PhotoItem",
                  bundle: nil),
            forCellWithReuseIdentifier: "photoItem")
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
        return photos!.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if first {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "photoCollectionCell",
                for: indexPath)
                    as? PhotoCollectionCell
            else { return UICollectionViewCell() }
            
            cell.configure(image: UIImage(named: "Friends/\(personName)") ?? UIImage(),
                           name: personName,
                           age: personAge!)
            print(indexPath.row)
            self.first = false
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "photoItem",
                for: indexPath)
                    as? PhotoItem
            else { return UICollectionViewCell() }
            
            cell.configure(image: UIImage(named: "Collections/\(personName)/caption\(indexPath.row)") ?? UIImage())
            
            return cell
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
