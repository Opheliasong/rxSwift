//
//  GithubEndpoint.swift
//  rxSwiftExam
//
//  Created by Sung Min Park on 2021/04/29.
//

import Foundation
import Moya

fileprivate extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

enum GithubIssueEndPoint {
    case userProfile(username: String)
    case repos(username: String)
    case repo(fullName: String)
    case issues(repositoryFullName: String)
}

extension GithubIssueEndPoint: TargetType {
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
            case .repos(_):
                return "}".data(using: .utf8)!
            case .userProfile(let name):
                return "{\"login\": \"\(name)\", \"id\": 100}".data(using: .utf8)!
            case .repo(_):
                return "{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}".data(using: .utf8)!
            case .issues(_):
                return "{\"id\": 132942471, \"number\": 405, \"title\": \"Updates example with fix to String extension by changing to Optional\", \"body\": \"Fix it pls.\"}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    
    var path: String {
        switch self {
            case .repos(let name):
                return "/users/\(name)/repos"
            case .userProfile(let name):
                return "/users/\(name)"
            case .repo(let name):
                return "/repos/\(name)"
            case .issues(let repoFullName):
                print("FullName: \(repoFullName)")
                return "/repos/\(repoFullName)/issues"
        }
    }
}
