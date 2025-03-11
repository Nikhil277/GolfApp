//
//  GolfCourseListingModel.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

struct GolfCourseListResponse: Codable {
    let courses: [GolfCourseDataModel]
    
    enum CodingKeys: String, CodingKey {
        case courses
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.courses = container?.safeDecode([GolfCourseDataModel].self, forKey: .courses) ?? []
    }
}

struct GolfCourseDataModel: Codable {
    let id, clubName, courseName: String
    let location: LocationModel?
    
    enum CodingKeys: String, CodingKey {
        case id, location
        case clubName = "club_name"
        case courseName = "course_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.id = container?.decodeAsString(.id) ?? "" // Assumes we will always get a proper id from server
        self.clubName = container?.decodeAsString(.clubName) ?? ""
        self.courseName = container?.decodeAsString(.courseName) ?? ""
        self.location = container?.safeDecode(LocationModel.self, forKey: .location)
    }
    
    init(id: String = "", clubName: String = "", courseName: String = "", location: LocationModel? = nil) {
        self.id = id
        self.clubName = clubName
        self.courseName = courseName
        self.location = location
    }
}

struct LocationModel: Codable { // Demo project - Only took 1 value
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case address
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.address = container?.decodeAsString(.address) ?? ""
    }
    
    init(address: String = "") {
        self.address = address
    }
}
