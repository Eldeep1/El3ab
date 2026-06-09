//
//  NetworkService.swift
//  El3ab
//

import Alamofire
import Foundation

protocol NetworkServiceProtocol {
    func fetchLeagues(sport: Sport, completion: @escaping (Result<[Leagues], Error>) -> Void)
    func fetchTeamDetails(sport: Sport, teamId: String, completion: @escaping (Result<Team, Error>) -> Void)
    func fetchEventDetails(sport: Sport, leagueId: String, from:String, to:String, completion: @escaping (Result<[Event], Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {

    
    static let shared = NetworkService()
    private init() {}
    
    func fetchLeagues(sport: Sport, completion: @escaping (Result<[Leagues], Error>) -> Void) {
        print("Fetching leagues for sport: \(sport.rawValue)")
        
        AF.request(APIRouter.getLeagues(sport: sport))
            .validate()
            .responseDecodable(of: LeagueResponse.self) { response in
                switch response.result {
                case .success(let leagueResponse):
                    if leagueResponse.success == 1, let result = leagueResponse.result {
                        let leagues = result.map { $0.toLeague() }
                        print("Successfully fetched \(leagues.count) leagues")
                        completion(.success(leagues))
                    } else {
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "API returned unsuccessful response"])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Network error: \(error.localizedDescription)")
                    if let data = response.data {
                        let jsonString = String(data: data, encoding: .utf8)
                        print("Error response: \(jsonString ?? "No data")")
                    }
                    completion(.failure(error))
                }
            }
    }
    
    func fetchTeamDetails(sport: Sport, teamId: String, completion: @escaping (Result<Team, Error>) -> Void) {
         print("Fetching team details for sport: \(sport.rawValue), teamId: \(teamId)")
         
         // First, get the raw response to see what we're getting
         AF.request(APIRouter.getTeamDetails(sport: sport, teamId: teamId))
             .responseString { response in
                 switch response.result {
                 case .success(let string):
                     print("Raw Team Response: \(string)")
                     
                     // Try to decode the response
                     if let data = string.data(using: .utf8) {
                         do {
                             let decoder = JSONDecoder()
                             let teamResponse = try decoder.decode(TeamResponse.self, from: data)
                             
                             if teamResponse.success == 1, let firstTeam = teamResponse.result.first {
                                 print("Successfully fetched team: \(firstTeam.teamName)")
                                 completion(.success(firstTeam.toTeam()))
                             } else {
                                 let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No team found in response"])
                                 completion(.failure(error))
                             }
                         } catch {
                             print("Decoding error: \(error)")
                             completion(.failure(error))
                         }
                     } else {
                         let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])
                         completion(.failure(error))
                     }
                     
                 case .failure(let error):
                     print("Network error: \(error)")
                     completion(.failure(error))
                 }
             }
     }
    
    func fetchEventDetails(sport: Sport, leagueId: String, from: String, to: String, completion: @escaping (Result<[Event], Error>) -> Void) {
        
        AF.request(APIRouter.getEvents(sport: sport, leagueId: leagueId, from: from, to: to))
            .validate()
            .responseDecodable(of: EventResponse.self) { response in
                switch response.result {
                case .success(let eventResponse):
                    if eventResponse.success == 1, let result = eventResponse.result {
                        let events = result.map { $0.toEvent() }
                        print("Successfully fetched \(events.count) events")
                        completion(.success(events))
                    } else {
                        let error = NSError(
                            domain: "APIRouterErrorDomain",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "API returned an unsuccessful status or empty results."]
                        )
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print("Network error: \(error.localizedDescription)")
                    if let data = response.data {
                        let jsonString = String(data: data, encoding: .utf8)
                        print("Error response payload: \(jsonString ?? "No string representation")")
                    }
                    completion(.failure(error))
                }
            }
    }
        
     
    }
    

