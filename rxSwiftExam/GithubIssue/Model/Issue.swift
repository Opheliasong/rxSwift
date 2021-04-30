//
//  Issue.swift
//  rxSwiftExam
//
//  Created by Sung Min Park on 2021/04/29.
//

import Foundation
import Mapper

struct GithubIssueModel: Mappable, Codable {
    let identifier: Int
    let number: Int
    let title: String
    let body: String
    
    internal init(identifier: Int, number: Int, title: String, body: String) {
        self.identifier = identifier
        self.number = number
        self.title = title
        self.body = body
    }
    
    init(map: Mapper) throws {
        try identifier = map.from("id")
        try number = map.from("number")
        try title = map.from("title")
        try body = map.from("body")
    }
    
    enum CodingKeys: String, CodingKey {		
        case identifier = "id"
        case number = "number"
        case title = "title"
        case body = "body"
    }
}
