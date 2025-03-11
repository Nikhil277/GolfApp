//
//  GolfCourseListingView.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

import SwiftUI

struct GolfCourseListingView: View {
    @StateObject var viewModel: GolfCourseListingViewModel = GolfCourseListingViewModel()
    @State var searchText: String = ""

    var body: some View {
        VStack(spacing: 10) {
            Text("Golf Courses")
                .font(.semibold(24))
                .padding(.top, 20)
            
            GolfCourseListingSearchView(searchText: $searchText, onUpdate: {
                updateSearchSuggestion()
            })
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .padding(.top, 10)
            
            if viewModel.isInitialApiCallInProgress {
                Text("Fetching data...")
                    .font(.regular(13))
                    .padding(.top, 50)
            } else if viewModel.courseList.count > 0 {
                List(Array(viewModel.courseList.enumerated()), id: \.offset) { index, courseData in
                    
                    GolfCourseListingCell(courseData: courseData)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 15)
                }
                .listStyle(.plain)
                .scrollDismissesKeyboard(.interactively)
            } else if searchText == "" && !viewModel.isApiCallInProgress {
                Text("Search to get results")
                    .font(.regular(13))
                    .padding(.top, 50)
            } else if !viewModel.isApiCallInProgress {
                Text("No results found!")
                    .font(.regular(13))
                    .padding(.top, 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color.background
                .ignoresSafeArea()
        )
        .onFirstAppear {
            viewModel.fetchGolfCourseListingMetadata("")
        }
    }
}

extension GolfCourseListingView {
    func updateSearchSuggestion() {
        viewModel.fetchGolfCourseListingMetadata(searchText)
    }
}

#Preview {
    GolfCourseListingView()
}
