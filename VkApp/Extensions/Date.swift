//
//  Date.swift
//  VkApp
//
//  Created by Карим Руабхи on 02.04.2022.
//

import Foundation

extension Date {
    enum DateFormat: String {
        case dateTime = "dd.MM.yy в HH:mm"
        case date = "dd.MM.yy"
        case day = "dd"
        case time = "HH:mm"
    }
    
    func toString(dateFormat: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        let str = dateFormatter.string(from: self)
        return str
    }
}
