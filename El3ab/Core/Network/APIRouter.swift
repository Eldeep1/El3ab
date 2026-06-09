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
    case getEvents(sport: Sport, leagueId: String, from: String, to: String)
    
    private var method: HTTPMethod {
        switch self {
        case .getLeagues, .getTeamDetails, .getEvents:
            return .get
        }
    }
    
    private var path: String {
            switch self {
            case .getLeagues(let sport),
                 .getTeamDetails(let sport, _),
                 .getEvents(let sport, _, _, _):
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
        case .getEvents(_, let leagueId, let from, let to):
            return [
                "met" : "Fixtures",
                "APIkey": Constants.apiKey,
                "leagueId":leagueId,
                "from":from,
                "to":to
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
