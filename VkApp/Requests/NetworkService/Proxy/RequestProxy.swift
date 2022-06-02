//
//  File.swift
//  VkApp
//
//  Created by Карим Руабхи on 02.06.2022.
//

import Foundation

final class RequestProxy<ItemsType: Decodable>: RequestService {
    
    let request: Request<ItemsType>
    
    func fetch(
        type: requestType,
        str: String? = "",
        id: Int? = 0,
        complition: @escaping (Swift.Result<[ItemsType], Error>) -> Void
    ) {
        print("was sent a request to receive \(type)")
        
        request.fetch(
            type: type,
            str: str,
            id: id,
            complition: complition
        )
    }
    
    init(request: Request<ItemsType>) {
        self.request = request
    }
}
