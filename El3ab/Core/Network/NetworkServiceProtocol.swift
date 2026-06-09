//
//  NetworkService.swift
//  El3ab
//

import Alamofire
import Foundation

protocol NetworkServiceProtocol {
    func fetchLeagues(sport: Sport, completion: @escaping (Result<[Leagues], Error>) -> Void)
    func fetchTeamDetails(sport: Sport, teamId: String, completion: @escaping (Result<Team, Error>) -> Void)
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
        
        AF.request(APIRouter.getTeamDetails(sport: sport, teamId: teamId))
            .validate()
            .responseDecodable(of: TeamResponse.self) { response in
                switch response.result {
                case .success(let teamResponse):
                    if teamResponse.success == 1, let firstTeam = teamResponse.result.first {
                        print("Successfully fetched team: \(firstTeam.teamName)")
                        completion(.success(firstTeam.toTeam()))
                    } else {
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No team found"])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Network error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}
