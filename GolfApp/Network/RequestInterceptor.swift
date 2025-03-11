//
//  Untitled.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

import Foundation
import Alamofire
import UIKit

final class RequestInterceptor: Alamofire.RequestInterceptor {

    func adapt(_ urlRequest: URLRequest, using state: RequestAdapterState, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(AppUrl.baseURL) == true else {
            /// If the request does not require authentication, we can directly return it as unmodified.
            return completion(.success(urlRequest))
        }
        var urlRequest = urlRequest

        urlRequest.setValue("Key K33FH3QSAYMDAHDK5JCEADJIYY", forHTTPHeaderField: "authorization") // Applying the API key directly here.

        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {

        guard let response = request.task?.response as? HTTPURLResponse, (response.statusCode == 401) else {
            /// The request did not fail due to a 401 Unauthorized response.
            /// Return the original error and don't retry the request.
            return completion(.doNotRetryWithError(error))
        }

        // Demo project - Not wired
        // Handle token refresh and check appropriate error codes
    }
}
