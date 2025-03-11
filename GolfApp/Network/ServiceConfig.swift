//
//  ServiceConfig.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

struct AppUrl {
    private struct Domains {
        static let live  = ""
        static let dev   = ""
        static let uat   = ""
        static let qa    = "https://api.golfcourseapi.com" // swiftlint:disable:this identifier_name
        static let local = ""
    }
    
    static let baseURL = Domains.qa

    static let termsAndConditions = ""
    static let privacyPolicy = ""
        
    static func isDev() -> Bool {
        return baseURL == Domains.dev
    }
    
    static func isQA() -> Bool {
        return baseURL == Domains.qa
    }
    
    static func isUat() -> Bool {
        return baseURL == Domains.uat
    }

    static func isProd() -> Bool {
        return baseURL == Domains.live
    }
}

struct ApiName {
    static let golfCourseList = "/v1/search"
    static let golfCourseDetail = "/v1/courses"
}


enum HTTPMETHOD {
    case POST
    case GET
    case PUT
    case DELETE
}

enum UPLOADFILETYPE {
    case IMAGE
    case VIDEO
    case AUDIO
}

enum ServerResponseCodes: String, Codable {
    // Success cases
    case dataFetchSuccess = "Empty1"
    case loginSuccess = "Empty2"
    // Failure cases
    case unauthenticatedUser = "Empty3"
    case badRequest = "Empty4"
}
