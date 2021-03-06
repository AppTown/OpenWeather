//
//  JSONSerializable.swift
//  OpenWeather
//
//  Created by Dario Banno on 29/05/2017.
//  Copyright © 2017 AppTown. All rights reserved.
//

import Foundation

typealias JSONObject = [String: Any]

protocol JSONSerializable {
    init?(json: JSONObject?)
}

extension JSONSerializable {
    
    func toJSONObject() -> JSONObject {
        var json = JSONObject()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
            case let value as JSONSerializable:
                json[label] = value.toJSONObject()
            case let value as NSObject:
                json[label] = value
            default:
                Logger.print("Error: \(label) is unserializable for value \(value)")
            }
        }
        
        return json
    }
    
}

extension Array where Element: JSONSerializable {
    
    /**
     Initialize an array based on a json dictionary
     
     - parameter jsonArray: The json array
     */
    init?(jsonArray: [JSONObject]?) {
        self.init()
        
        guard let jsonArray = jsonArray else { return }
        
        for json in jsonArray {
            guard let element = Element(json: json) else {
                // Fail initializer if an element cannot be serialised.
                return nil
            }
            self += [element]
        }
    }
    
    func toJSONArray() -> [JSONObject] {
        return map { $0.toJSONObject() }
    }
    
}
