//
//  GolfCourseListingViewModel.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

import Foundation

class GolfCourseListingViewModel: ObservableObject {
    @Published var isInitialApiCallInProgress: Bool = true
    @Published var isApiCallInProgress: Bool = false
    @Published var courseList: [GolfCourseDataModel] = []
    
    // MARK: - Helper functions

    // MARK: - API calls
    func fetchGolfCourseListingMetadata(_ searchQuery: String) {
        if !isApiCallInProgress {
            isApiCallInProgress = true
            let params = ["search_query": searchQuery]
            ServerInterface.sharedInstance.requestWithAccessToken(apiName: ApiName.golfCourseList, params: nil, method: .GET, delegate: self, urlParams: params)
        }
    }
    
    // MARK: - API response handlers
    func handleResponseForGolfCourseListing(_ response: Any) {
        if let data = (response as? Data)?.getDecodedObject(from: GolfCourseListResponse.self)?.courses {
            courseList = data
            isApiCallInProgress = false
            isInitialApiCallInProgress = false
            print("Got list data")
        }
    }
}

extension GolfCourseListingViewModel: ServerInterfaceDelegate {
    func apiCallbackResponse(apiName: String, responseData: Any) {
        switch apiName {
        case ApiName.golfCourseList:
            self.handleResponseForGolfCourseListing(responseData)
        default:
            print("Unhandled api success response - \(apiName)")
        }
        
    }
    
    func apiCallbackError(apiName: String, errorMessage: String, responseData: Any?) {
        switch apiName {
        case ApiName.golfCourseList:
            isApiCallInProgress = false
            isInitialApiCallInProgress = false
            print("Error response not handled yet")
        default:
            print("Unhandled api error response - \(apiName)")
        }
    }

}
