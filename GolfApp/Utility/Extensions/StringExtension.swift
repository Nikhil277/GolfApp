//
//  StringExtension.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

import Foundation
import UIKit
import SwiftUI

extension String {
    func toJSONData() -> Data? {
        if let jsonData = self.data(using: .utf8) {
            return jsonData
        } else {
            print("Failed to convert jsonString to Data")
            return nil
        }
    }
    
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }

    func toDictionary() -> [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
    }
}
