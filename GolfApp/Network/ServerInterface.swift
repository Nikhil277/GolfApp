//
//  ServerInterface.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

import Foundation
import UIKit
import Alamofire

protocol ServerInterfaceDelegate: AnyObject {
    func apiCallbackResponse(apiName: String, responseData: Any)
    func apiCallbackError(apiName: String, errorMessage: String, responseData: Any?)
}

class ServerInterface: NSObject {
    static let sharedInstance = ServerInterface()
    private override init() {}

    // MARK: - API calling functions
    /*
     To make API call to server and fetching datas.
     - parameter apiName: Name of API, For example: AppUrl.login .
     - parameter params: Parameters of API call, can be nil or a dictionary
     - parameter method: HTTP method.
     - parameter showLoader: true for showing activity indicator. false otherwise
     - parameter delegate: Set ServerInterfaceDelegate to handle web response.
     - parameter urlParams: If api uses url parameters use this to pass the params instead of 'params'
     */
    
    func requestWithAccessToken(apiName: String, params: [String: Any]? = nil, method: HTTPMETHOD = .POST, showLoader: Bool = false, delegate: ServerInterfaceDelegate, urlParams: [String: String]? = nil) {
        var urlString = ""
        urlString = AppUrl.baseURL + apiName

        if urlParams != nil {
            urlString += getUrlParamsString(urlParams!)
        }

        let requestMethod = getHTTPMethod(method)

        let requestInterceptor = RequestInterceptor()
        let isNetworkConnected = true // Demo Project - Not wired

        if isNetworkConnected {
            if showLoader {
                DispatchQueue.main.async {
                    // SwiftLoader.show(animated: true) // Demo Project - Not wired
                }
            }

            AF.request(urlString, method: requestMethod, parameters: params, encoding: JSONEncoding.default, interceptor: requestInterceptor, requestModifier: { $0.timeoutInterval = 60 }).validate().response { response in
                DispatchQueue.main.async {
                    if showLoader {
                        // SwiftLoader.hide() // Demo Project - Not wired
                    }

                    if self.checkIfSuccessResponse(response) {
                        delegate.apiCallbackResponse(apiName: apiName, responseData: response.value! as Any)
                    } else {
                        let errorMsg = self.handleErrorResponse(response)
                        delegate.apiCallbackError(apiName: apiName, errorMessage: errorMsg, responseData: response.value as Any?)
                    }
                }
            }
        } else { // No internet connection
            let networkError = "Check your network connection"
            delegate.apiCallbackError(apiName: apiName, errorMessage: networkError, responseData: nil)
            // NoNetworkHandler.showInternetView()  // Demo Project - Not wired
        }
    }

    
    // MARK: - Local json loading
    
    func readLocalJson(forname apiName: String, delegate: ServerInterfaceDelegate) {
        if let path = Bundle.main.path(forResource: apiName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                delegate.apiCallbackResponse(apiName: apiName, responseData: data as Any)
            } catch {
                print("error")
            }
        }
    }
        

    // MARK: - HTTP Method

    func getHTTPMethod(_ method: HTTPMETHOD) -> HTTPMethod {
        if method == .GET {
            return(.get)
        } else if method == .POST {
            return(.post)
        } else if method == .DELETE {
            return(.delete)
        } else if method == .PUT {
            return(.put)
        } else {
            return(.post)
        }
    }
    
    func checkIfSuccessResponse(_ response: AFDataResponse<Data?>) -> Bool {
        var isSuccess = false
        
        // First check status from connection
        if let statusCode = response.response?.statusCode, statusCode == 200, response.value != nil {
            isSuccess = true
            // Demo Project - Not wired
            // Check Server returned success codes and handle accordingly
        }
        
        return isSuccess
    }
    
    func handleErrorResponse(_ response: AFDataResponse<Data?>) -> String {
        let error = "Unable to connect to server."
        
        // Demo Project - Not wired
        // Check Server returned error codes and handle accordingly
        
        return error
    }


    func getUrlParamsString(_ data: [String: String]) -> String {
        var urlString = ""
        for (key, value) in data {
            if urlString == "" {
                urlString = "?" + key + "=" + value.urlEncoded
            } else {
                urlString = urlString + "&" + key + "=" + value.urlEncoded
            }
        }
        return urlString
    }
}
