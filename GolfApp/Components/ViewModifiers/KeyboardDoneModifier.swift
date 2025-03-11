//
//  KeyboardDoneModifier.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

import SwiftUI

struct KeyboardDoneButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15, *) {
            return content.toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        Utils.sharedInstance.hideKeyboard()
                    } label: {
                        Text("Done")
                    }
                }
            }
        } else {
            return EmptyView()
        }
    }
}
