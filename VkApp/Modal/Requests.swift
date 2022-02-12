//
//  Requests.swift
//  VkApp
//
//  Created by Карим Руабхи on 12.02.2022.
//

import Foundation

final class Request {
    
    static func getFriends() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/friends.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(SessionData.data.userId)),
            URLQueryItem(name: "order", value: "random"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "access_token", value: SessionData.data.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        var request = URLRequest(url: urlConstructor.url!)
        request.httpMethod = "POST"
        let task = session.dataTask(with: request) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print(json)
        }
        task.resume()
    }
    
    static func getPhotos() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/photos.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "owner_id", value: String(SessionData.data.userId)),
            URLQueryItem(name: "album_id", value: "profile"),
            URLQueryItem(name: "rev", value: "0"),
            URLQueryItem(name: "photo_sizes", value: "1"),
            URLQueryItem(name: "access_token", value: SessionData.data.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        var request = URLRequest(url: urlConstructor.url!)
        request.httpMethod = "POST"
        let task = session.dataTask(with: request) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print(json)
        }
        task.resume()
    }
    
    static func getGroups() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/groups.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(SessionData.data.userId)),
            URLQueryItem(name: "access_token", value: SessionData.data.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        var request = URLRequest(url: urlConstructor.url!)
        request.httpMethod = "POST"
        let task = session.dataTask(with: request) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print(json)
        }
        task.resume()
    }
    
    static func searchGroups(str: String, count: Int) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/groups.search"
        urlConstructor.queryItems = [
            URLQueryItem(name: "q", value: str),
            URLQueryItem(name: "type", value: "group"),
            URLQueryItem(name: "sort", value: "6"),
            URLQueryItem(name: "count", value: String(count)),
            URLQueryItem(name: "access_token", value: SessionData.data.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        var request = URLRequest(url: urlConstructor.url!)
        request.httpMethod = "POST"
        let task = session.dataTask(with: request) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print(json)
        }
        task.resume()
    }
}
