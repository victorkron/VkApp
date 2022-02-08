//
//  Singleton.swift
//  VkApp
//
//  Created by Карим Руабхи on 08.02.2022.
//


final class SessionData {
    var token: String = ""
    var userId: Int = 0
    
    static let data = SessionData()
    
    private init() {}
}
