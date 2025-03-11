//
//  Utils.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

import Foundation
import UIKit

class Utils: NSObject {

    // MARK: - Declarations

    static let sharedInstance = Utils()
    private override init() {}
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
