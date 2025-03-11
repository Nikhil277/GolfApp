//
//  DictionaryExtension.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

import Foundation

extension Data {
    func getDecodedObject<T>(from object: T.Type) -> T? where T: Decodable {
        do {
            return try JSONDecoder().decode(object, from: self)
        } catch let error {
            print("Manually parsed  ", (try? JSONSerialization.jsonObject(with: self, options: .mutableContainers)) ?? "nil")
            print("Error in Decoding OBject ", String(describing: error))
            return nil
        }
    }
    
    func jsonString() -> String? {
        if let dict = (try? JSONSerialization.jsonObject(with: self, options: .mutableContainers)) {
            let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
            let json = String(data: jsonData ?? self, encoding: .utf8)
            return json
        }
        return ""
    }    
}
