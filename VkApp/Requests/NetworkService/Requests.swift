//
//  Requests.swift
//  VkApp
//
//  Created by Карим Руабхи on 12.02.2022.
//

import Foundation

final class Request {
    func getFriends(complition: @escaping (Result<Friends, Error>) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/friends.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(SessionData.data.userId)),
            URLQueryItem(name: "order", value: "hints"),
            URLQueryItem(name: "count", value: "200"),
            URLQueryItem(name: "fields", value: "nickname,photo_100"),
            URLQueryItem(name: "access_token", value: SessionData.data.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        guard let
                url = urlConstructor.url
        else { return }
        
        var request = URLRequest(url: url)
        //        print("Here",urlConstructor.url!)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard
                error == nil,
                let data = data
            else { return }
            do {
                let friendsResponse = try JSONDecoder().decode(FriendsResponse.self, from: data)
                complition(.success(friendsResponse.response))
            } catch {
                complition(.failure(error))
            }
        }
        task.resume()
    }
    
    func getPhotos(id: String, complition: @escaping (Result<Photos,Error>) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/photos.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "owner_id", value: id),
            URLQueryItem(name: "album_id", value: "profile"),
            URLQueryItem(name: "rev", value: "1"),
            URLQueryItem(name: "photo_sizes", value: "0"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: SessionData.data.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
                
        guard let
                url = urlConstructor.url
        else { return }
        
        var request = URLRequest(url: url)
        //        print("Here",urlConstructor.url!)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard
                error == nil,
                let data = data
            else { return }
            do {
                let photosResponse = try JSONDecoder().decode(PhotosResponse.self, from: data)
                complition(.success(photosResponse.response))
            } catch {
                complition(.failure(error))
            }
            
            
        }
        task.resume()
    }
    
    func getGroups(complition: @escaping (Result<Groups, Error>) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/groups.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(SessionData.data.userId)),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: SessionData.data.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        guard let
                url = urlConstructor.url
        else { return }
        
        var request = URLRequest(url: url)
        //        print("Here",urlConstructor.url!)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard
                error == nil,
                let data = data
            else { return }
            do {
                let groupsResponse = try JSONDecoder().decode(GroupsResponse.self, from: data)
                complition(.success(groupsResponse.response))
            } catch {
                complition(.failure(error))
            }
            
            
        }
        task.resume()
    }
    
    func searchGroups(str: String, count: Int, complition: @escaping (Result<Groups,Error>) -> Void) {
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
        
        guard let
                url = urlConstructor.url
        else { return }
        
        var request = URLRequest(url: url)
        //        print("Here",urlConstructor.url!)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard
                error == nil,
                let data = data
            else { return }
            do {
                let groupsResponse = try JSONDecoder().decode(GroupsResponse.self, from: data)
                complition(.success(groupsResponse.response))
            } catch {
                complition(.failure(error))
            }
            
            
        }
        task.resume()
    }
    
    func addGroup(id: Int) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/groups.search"
        urlConstructor.queryItems = [
            URLQueryItem(name: "group_id", value: String(id)),
            URLQueryItem(name: "not_sure", value: "0"),
            URLQueryItem(name: "access_token", value: SessionData.data.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        guard let
                url = urlConstructor.url
        else { return }
        
        var request = URLRequest(url: url)
        //        print("Here",urlConstructor.url!)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
        }
        task.resume()
    }
}
