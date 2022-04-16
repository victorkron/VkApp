//
//  RegisterItems.swift
//  VkApp
//
//  Created by Карим Руабхи on 03.04.2022.
//

import Foundation
import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension UITableView {
    func register<T: UITableViewCell>(registerClass: T.Type) {
        let defaultReuseIdentifier = registerClass.defaultReuseIdentifier
        register(UINib(nibName: defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}

extension UITableViewCell: ReusableView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
