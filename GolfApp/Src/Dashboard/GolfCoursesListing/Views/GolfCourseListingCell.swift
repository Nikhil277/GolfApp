//
//  GolfCourseListingCell.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

import SwiftUI

struct GolfCourseListingCell: View {
    let courseData: GolfCourseDataModel
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(courseData.courseName)
                    .font(.regular(16))
                    .foregroundStyle(Color.primaryText)
                
                Text(courseData.clubName)
                    .font(.regular(14))
                    .foregroundStyle(Color.secondaryText)
                
                Text(courseData.location?.address ?? "")
                    .font(.regular(12))
                    .foregroundStyle(Color.secondaryText)
            }
            
            Spacer()
            
            Button {
                print("Navigate to detail screen")
            } label: {
                Image(AppImages.Common.next)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
            }
            .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

#Preview {
    GolfCourseListingCell(courseData: GolfCourseDataModel(id: "1", clubName: "TestClub", courseName: "TestCourse", location: LocationModel(address: "xyz location")))
}
