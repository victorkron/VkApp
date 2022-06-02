//
//  RequestInterface.swift
//  VkApp
//
//  Created by Карим Руабхи on 02.06.2022.
//

import Foundation
import PromiseKit

enum requestType {
    case friends
    case groups
    case photos
    case searchGroups
    case feed
}

protocol RequestService {
    associatedtype Element
    func fetch(type: requestType, str: String?, id: Int?, complition: @escaping (Swift.Result<Element, Error>) -> Void)
}
