//
//  APIRouter.swift
//  El3ab
//
//  Created by Osama Khaled on 09/06/2026.
//

import Alamofire
import Foundation

enum APIRouter: URLRequestConvertible {
    case getLeagues(sport: Sport)
    case getTeamDetails(sport: Sport, teamId: String)
    
    private var method: HTTPMethod {
        switch self {
        case .getLeagues, .getTeamDetails:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .getLeagues(let sport):
            return "/\(sport.rawValue)/"
        case .getTeamDetails(let sport, _):
            return "/\(sport.rawValue)/"
        }
    }
    
    private var parameters: Parameters {
        switch self {
        case .getLeagues:
            return [
                "met": "Leagues",
                "APIkey": Constants.apiKey
            ]
        case .getTeamDetails(_, let teamId):
            return [
                "met": "Teams",
                "APIkey": Constants.apiKey,
                "teamId": teamId
            ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.method = method        
        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}
