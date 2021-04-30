//
//  Repository.swift
//  rxSwiftExam
//
//  Created by Sung Min Park on 2021/04/29.
//

import Foundation
import Mapper

struct Repository : Mappable, Codable {
    private init(identify: Int, language: String, name: String, fullName: String) {
        self.identify = identify
        self.language = language
        self.name = name
        self.fullName = fullName
    }
    
    let identify: Int
    let language: String
    let name: String
    let fullName: String
    
    init(map: Mapper) throws {
        try identify = map.from("id")
        try language = map.from("language")
        try name = map.from("name")
        try fullName = map.from("full_name")
    }

    
    enum CodingKeys: String, CodingKey {
        case identify = "id"
        case language = "language"
        case name = "name"
        case fullName = "full_name"
    }
    
    static func empty() -> Repository {
        let empty = Repository.init(identify: 0, language: "", name: "", fullName: "")
        return empty
    }
}
