//
//  KeyedDecodingContainerExtension.swift
//  Peck
//
//  Created by Nikhil B Kuriakose on 21/08/23.
//

import Foundation

extension KeyedDecodingContainer {
    
    /// To decode given value to string
    ///
    /// - Parameters:
    ///     - key: KeyedDecodingContainer<K>.Key. Key used to decode value
    ///
    /// - Returns: decoded string. If decoding fails - will return nil
    func decodeAsString(_ key: KeyedDecodingContainer<K>.Key) -> String? {
        if let stringValue = try? self.decode(String.self, forKey: key) {
            return stringValue
        } else if let intValue = try? self.decode(Int.self, forKey: key) {
            return intValue.description
        } else if let doubleValue = try? self.decode(Double.self, forKey: key) {
            return doubleValue.description
        } else if let boolValue = try? self.decode(Bool.self, forKey: key) {
            return boolValue.description
        } else {
            printDecodeFail(key)
            return nil
        }
    }
    
    /// To decode given value to boolean
    ///
    /// - Parameters:
    ///     - key: KeyedDecodingContainer<K>.Key. Key used to decode value
    ///
    /// - Returns: decoded bool. If decoding fails - will return nil
    func decodeAsBoolean(_ key: KeyedDecodingContainer<K>.Key) -> Bool? {
        if let value = try? self.decode(Bool.self, forKey: key) {
            return value
        } else if let value = try? self.decode(Int.self, forKey: key) {
            if value == 0 {
                return false
            } else if value == 1 {
                return true
            } else {
                return nil
            }
        } else if let value = try? self.decode(Double.self, forKey: key) {
            if value == 0 {
                return false
            } else if value == 1 {
                return true
            } else {
                return nil
            }
        } else if let value = try? self.decode(String.self, forKey: key) {
            if value.lowercased() == "true" || value.lowercased() == "yes" {
                return true
            } else if value.lowercased() == "false" || value.lowercased() == "no" {
                return false
            } else {
                return nil
            }
        } else {
            printDecodeFail(key)
            return nil
        }
    }

    /// To decode given value to integer
    ///
    /// - Parameters:
    ///     - key: KeyedDecodingContainer<K>.Key. Key used to decode value
    ///
    /// - Returns: decoded Int. If decoding fails - will return nil
    func decodeAsInt(_ key: KeyedDecodingContainer<K>.Key) -> Int? {
        if let value = try? self.decode(Int.self, forKey: key) {
            return value
        } else if let value = try? self.decode(Bool.self, forKey: key) {
            if value == true {
                return 1
            } else if value == false {
                return 0
            } else {
                return nil
            }
        } else if let value = try? self.decode(Double.self, forKey: key) {
            return Int(value)
        } else if let value = try? self.decode(String.self, forKey: key) {
            if let intValue = Int(value) {
                return intValue
            } else {
                return nil
            }
        }
        printDecodeFail(key)
        return nil
    }
    
    /// To decode given value to double
    ///
    /// - Parameters:
    ///     - key: KeyedDecodingContainer<K>.Key. Key used to decode value
    ///
    /// - Returns: decoded double. If decoding fails - will return nil
    func decodeAsDouble(_ key: KeyedDecodingContainer<K>.Key) -> Double? {
        if let value = try? self.decode(Double.self, forKey: key) {
            return value
        } else if let value = try? self.decode(Bool.self, forKey: key) {
            if value == true {
                return 1.0
            } else if value == false {
                return 0.0
            } else {
                return nil
            }
        } else if let value = try? self.decode(Int.self, forKey: key) {
            return Double(value)
        } else if let value = try? self.decode(String.self, forKey: key) {
            if let doubleValue = Double(value) {
                return doubleValue
            } else {
                return nil
            }
        }
        printDecodeFail(key)
        return nil
    }
    
    /// To decode value of any type to same if possible else to return nil
    ///
    /// - Parameters:
    ///     - type: The Data Type we are expecting the API will pass
    ///     - key: KeyedDecodingContainer<K>.Key. Key used to decode value
    ///
    /// - Returns: decoded `Type`. If decoding fails - will return nil

    func safeDecode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) -> T? where T: Decodable {
        if let value = try? self.decode(type.self, forKey: key) {
            return value
        } else {
            printDecodeFail(key)
            return nil
        }
    }

    /// To decode message sent by Server, since it can be string or array
    ///
    /// - Parameters:
    ///     - key: KeyedDecodingContainer<K>.Key. Key used to decode value
    ///
    /// - Returns: decoded string. If decoding fails - will return nil
    func decodeMessage(_ key: KeyedDecodingContainer<K>.Key) -> String {
        // Message can come as string or as an array of strings
        if let value = try? self.decode(String.self, forKey: key) {
            return value
        } else if let value = try? self.decode([String].self, forKey: key) {
            return value.map { $0 }.joined(separator: "\n")
        } else {
            printDecodeFail(key)
            return ""
        }
    }

    // Just so it is easier to comment out
    func printDecodeFail(_ key: KeyedDecodingContainer<K>.Key) {
//        print("Decoding failed for key -  \(key)")
    }
}
