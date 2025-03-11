//
//  GolfCourseListingSearchView.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

import SwiftUI

struct GolfCourseListingSearchView: View {
    @Binding var searchText: String
    var onUpdate: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Image(AppImages.Common.search)
                .resizable()
                .scaledToFit()
                .frame(width: 18)
                .foregroundColor(Color.black)
            
            TextField("", text: $searchText)
                .onChange(of: searchText, { oldValue, newValue in
                    onUpdate()
                })
                .foregroundColor(.black)
                .accentColor(.black)
                .placeholder(when: searchText.isEmpty) {
                    Text("Search")
                        .foregroundStyle(Color.placeholder)
                        .font(.regular(14))
                }
                .modifier(KeyboardDoneButtonModifier())

            if searchText != "" {
                Button {
                    searchText = ""
                    onUpdate()
                } label: {
                    Image(systemName: "multiply.circle.fill")
                }
                .frame(width: 20)
                .foregroundColor(.black)
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 40)
        .background(.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 1)

    }
}

#Preview {
    GolfCourseListingSearchView(searchText: .constant(""), onUpdate: {})
}
