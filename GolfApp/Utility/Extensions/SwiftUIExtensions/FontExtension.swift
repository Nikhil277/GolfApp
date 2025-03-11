//
//  FontExtension.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

import SwiftUI

extension Font {
    private static func customFont(name: String, size: CGFloat) -> Font {
        return Font.custom(name, fixedSize: size)
    }
        
    static func regular(_ size: CGFloat) -> Font {
        return customFont(name: AppFont.regular, size: size)
    }
    
    static func semibold(_ size: CGFloat) -> Font {
        return customFont(name: AppFont.semibold, size: size)
    }
    
    static func medium(_ size: CGFloat) -> Font {
        return customFont(name: AppFont.medium, size: size)
    }
    
    static func bold(_ size: CGFloat) -> Font {
        return customFont(name: AppFont.bold, size: size)
    }    
}
