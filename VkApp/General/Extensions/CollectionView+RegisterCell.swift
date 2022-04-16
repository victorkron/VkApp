//
//  CollectionView+RegisterCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 12.04.2022.
//

import Foundation
import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(registerClass: T.Type) {
        let defaultReuseIdentifier = registerClass.defaultReuseIdentifier
        register(UINib(nibName: defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard
            let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func register<T: UICollectionReusableView>(registerClass: T.Type, forSupplementaryViewOfKind: String) {
        let defaultReuseIdentifier = registerClass.description().split(separator: ".")[1]
        register(
            UINib(nibName: String(defaultReuseIdentifier), bundle: nil),
            forSupplementaryViewOfKind: forSupplementaryViewOfKind,
            withReuseIdentifier: String(defaultReuseIdentifier)
        )
    }

    func dequeueReusableCell<T: UICollectionReusableView>(forIndexPath indexPath: IndexPath, kind: String) -> T {
        guard
            let cell = dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: String(T.description().split(separator: ".")[1]),
                for: indexPath
            ) as? T
        else {
            fatalError("Could not dequeue cell with identifier \(T.description().split(separator: ".")[1])")
        }
        return cell
    }
}


extension UICollectionViewCell: ReusableView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
