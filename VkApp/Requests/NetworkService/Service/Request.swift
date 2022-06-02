//
//  Requests.swift
//  VkApp
//
//  Created by Карим Руабхи on 12.02.2022.
//

import Foundation
import PromiseKit

final class Request<ItemsType: Decodable>: RequestService {
    
    enum AppError: Error {
        case notCorrectURL
        case errorTask
        case failedToDecode
        case loadError
    }
    
    var responseData: Data?
    
    lazy var session = URLSession.shared
    let scheme = "https"
    let host = "api.vk.com"
    
    private var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        return constructor
    }()
    
    func fetch(type: requestType, str: String? = "", id: Int? = 0, complition: @escaping (Swift.Result<[ItemsType], Error>) -> Void) {
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
            constructor.path = "/method/newsfeed.get"
            constructor.queryItems = [
                URLQueryItem(name: "filters", value: "post,photo"),
                URLQueryItem(name: "max_photos", value: "9"),
                URLQueryItem(name: "count", value: "10"),
                URLQueryItem(name: "source_ids", value: "friends,groups,pages"),
                URLQueryItem(name: "v", value: "5.131"),
                URLQueryItem(name: "access_token", value: SessionData.data.token),
            ]
        }
        
        guard let url = constructor.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
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
    
    
    // для Operation
    func getFriends(str: String? = "", id: Int? = 0) {
        var constructor = urlConstructor
        constructor.path = "/method/friends.get"
        constructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(SessionData.data.userId)),
            URLQueryItem(name: "order", value: "hints"),
            URLQueryItem(name: "count", value: "200"),
            URLQueryItem(name: "fields", value: "nickname,photo_50,photo_100,photo_200"),
            URLQueryItem(name: "access_token", value: SessionData.data.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        guard let url = constructor.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
            guard
                error == nil,
                let data = data
            else { return }
            self.responseData = data
        }
        task.resume()
    }
    
    // Для Promise
    func getGroupsUrl() -> Promise<URL> {
        var constructor = urlConstructor
        constructor.path = "/method/groups.get"
        constructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(SessionData.data.userId)),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: SessionData.data.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        return Promise { resolver in
            guard let url = constructor.url else {
                resolver.reject(AppError.notCorrectURL)
                return
            }
            resolver.fulfill(url)
        }
    }
    
    func getGroups(url: URL) -> Promise<Data> {
        return Promise { resolver in
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            self.session.dataTask(with: request) { (data, response, error) in
                guard
                    error == nil,
                    let data = data
                else {
                    resolver.reject(AppError.errorTask)
                    return
                }
                resolver.fulfill(data)
            }.resume()
        }
    }
    
    func  getParsedData(data: Data) -> Promise<[GroupData]> {
        return Promise { resolver in
            do {
                let json = try JSONDecoder().decode(GroupsResponse.self, from: data).response.items
                resolver.fulfill(json)
            } catch {
                resolver.reject(AppError.failedToDecode)
            }
        }
    }
    
    func saveToGroupsDatabse(groups: [GroupData], desination: UpdateGroupsFromRealm) -> Promise<Bool> {
        let destination = desination
        return Promise { resolver in
            let items = groups.map { i in
                RealmGroup(group: i)
            }
            DispatchQueue.main.async {
                do {
                    try RealmService.save(items: items)
                    destination.updateGroups()
                    resolver.fulfill(true)
                } catch {
                    resolver.reject(AppError.loadError)
                    print(error)
                }
            }
        }
    }
    
    // Для паттерна Pull-to-refresh
    
    func getNews(timeSince: String, complition: @escaping (Swift.Result<[ItemsType], Error>) -> Void) {
        var constructor = urlConstructor
        constructor.path = "/method/newsfeed.get"
        constructor.queryItems = [
            URLQueryItem(name: "start_time", value: timeSince),
            URLQueryItem(name: "filters", value: "post,photo"),
            URLQueryItem(name: "max_photos", value: "9"),
            URLQueryItem(name: "source_ids", value: "friends,groups,pages"),
            URLQueryItem(name: "v", value: "5.131"),
            URLQueryItem(name: "access_token", value: SessionData.data.token),
        ]
        guard let url = constructor.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
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
    
    // Для паттерна infinite scrolling
    
    func getNews(complition: @escaping (Swift.Result<NewsResponse, Error>) -> Void) {
        var constructor = urlConstructor
        constructor.path = "/method/newsfeed.get"
        constructor.queryItems = [
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "filters", value: "post,photo"),
            URLQueryItem(name: "max_photos", value: "9"),
            URLQueryItem(name: "source_ids", value: "friends,groups,pages"),
            URLQueryItem(name: "v", value: "5.131"),
            URLQueryItem(name: "access_token", value: SessionData.data.token),
        ]
        guard let url = constructor.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
            guard
                error == nil,
                let data = data
            else { return }
            do {
                if let jsonT = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            print(jsonT)
                         }
                let json = try JSONDecoder().decode(NewsResponse.self, from: data)
                complition(.success(json))
            } catch {
                complition(.failure(error))
            }
        }
        task.resume()
    }
    
    func getNews(nextFrom: String, complition: @escaping (Swift.Result<NewsResponse, Error>) -> Void) {
        var constructor = urlConstructor
        constructor.path = "/method/newsfeed.get"
        constructor.queryItems = [
            URLQueryItem(name: "start_from", value: nextFrom),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "filters", value: "post,photo"),
            URLQueryItem(name: "max_photos", value: "9"),
            URLQueryItem(name: "source_ids", value: "friends,groups,pages"),
            URLQueryItem(name: "v", value: "5.131"),
            URLQueryItem(name: "access_token", value: SessionData.data.token),
        ]
        guard let url = constructor.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
            guard
                error == nil,
                let data = data
            else { return }
            do {
                let json = try JSONDecoder().decode(NewsResponse.self, from: data)
                complition(.success(json))
            } catch {
                complition(.failure(error))
            }
        }
        task.resume()
    }
}


