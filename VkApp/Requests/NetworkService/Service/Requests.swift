//
//  Requests.swift
//  VkApp
//
//  Created by Карим Руабхи on 12.02.2022.
//

import Foundation

final class Request<ItemsType: Decodable> {
    
    enum requestType {
        case friends
        case groups
        case photos
        case searchGroups
        case feed
    }
    
//    let configuration = URLSessionConfiguration.default
//    let session = URLSession(configuration: configuration)
    
    lazy var session = URLSession.shared
    let scheme = "https"
    let host = "api.vk.com"
    
    private var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        return constructor
    }()
    
    func fetch(type: requestType, str: String? = "", id: Int? = 0, complition: @escaping (Result<[ItemsType], Error>) -> Void) {
        var constructor = urlConstructor
        switch type {
        case .friends:
            constructor.path = "/method/friends.get"
            constructor.queryItems = [
                URLQueryItem(name: "user_id", value: String(SessionData.data.userId)),
                URLQueryItem(name: "order", value: "hints"),
                URLQueryItem(name: "count", value: "200"),
                URLQueryItem(name: "fields", value: "nickname,photo_50,photo_100,photo_200"),
                URLQueryItem(name: "access_token", value: SessionData.data.token),
                URLQueryItem(name: "v", value: "5.131")
            ]
        case .groups:
            constructor.path = "/method/groups.get"
            constructor.queryItems = [
                URLQueryItem(name: "user_id", value: String(SessionData.data.userId)),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "access_token", value: SessionData.data.token),
                URLQueryItem(name: "v", value: "5.131")
            ]
        case .photos:
            constructor.path = "/method/photos.get"
            constructor.queryItems = [
                URLQueryItem(name: "owner_id", value: "\(id!)"),
                URLQueryItem(name: "album_id", value: "profile"),
                URLQueryItem(name: "rev", value: "1"),
                URLQueryItem(name: "photo_sizes", value: "0"),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "access_token", value: SessionData.data.token),
                URLQueryItem(name: "v", value: "5.131")
            ]
        case .searchGroups:
            constructor.path = "/method/groups.search"
            constructor.queryItems = [
                URLQueryItem(name: "q", value: str),
                URLQueryItem(name: "type", value: "group"),
                URLQueryItem(name: "sort", value: "6"),
                URLQueryItem(name: "count", value: "10"),
                URLQueryItem(name: "access_token", value: SessionData.data.token),
                URLQueryItem(name: "v", value: "5.131")
            ]
        case .feed:
            print("Feed")
        }
        
        guard let url = constructor.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard
                error == nil,
                let data = data
            else { return }
            do {
                let json = try JSONDecoder().decode(Response<ItemsType>.self, from: data)
                complition(.success(json.response.items))
            } catch {
                complition(.failure(error))
            }
        }
        task.resume()
    }
    
    
//    func addGroup(id: Int) {
//        let configuration = URLSessionConfiguration.default
//        let session = URLSession(configuration: configuration)
//
//        var urlConstructor = URLComponents()
//        urlConstructor.scheme = "https"
//        urlConstructor.host = "api.vk.com"
//        urlConstructor.path = "/method/groups.search"
//        urlConstructor.queryItems = [
//            URLQueryItem(name: "group_id", value: String(id)),
//            URLQueryItem(name: "not_sure", value: "0"),
//            URLQueryItem(name: "access_token", value: SessionData.data.token),
//            URLQueryItem(name: "v", value: "5.131")
//        ]
//
//        guard let
//                url = urlConstructor.url
//        else { return }
//
//        var request = URLRequest(url: url)
//        //        print("Here",urlConstructor.url!)
//        request.httpMethod = "GET"
//
//        let task = session.dataTask(with: request) { (data, response, error) in
//
//        }
//        task.resume()
//    }
}
