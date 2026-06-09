//
//  TeamResponse.swift
//  El3ab
//

import Foundation

struct TeamResponse: Codable {
    let success: Int
    let result: [TeamAPI]
}

struct TeamAPI: Codable {
    let teamKey: String
    let teamName: String
    let teamLogo: String
    let players: [PlayerAPI]?
    
    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case players = "players"
    }
    
    func toTeam() -> Team {
        let playerList = players?.map { $0.toPlayer() } ?? []
        
        return Team(
            name: teamName,
            logoImageName: teamLogo,
            players: playerList,
            coaches: []
        )
    }
}

struct PlayerAPI: Codable {
    let playerKey: Int?
    let playerName: String
    let playerNumber: String?
    let playerType: String?
    let playerAge: String?
    let playerMatchPlayed: String?
    let playerGoals: String?
    let playerYellowCards: String?
    let playerRedCards: String?
    
    enum CodingKeys: String, CodingKey {
        case playerKey = "player_key"
        case playerName = "player_name"
        case playerNumber = "player_number"
        case playerType = "player_type"
        case playerAge = "player_age"
        case playerMatchPlayed = "player_match_played"
        case playerGoals = "player_goals"
        case playerYellowCards = "player_yellow_cards"
        case playerRedCards = "player_red_cards"
    }
    
    func toPlayer() -> Player {
        return Player(
            name: playerName,
            imageName: "", 
            position: playerType,
            number: Int(playerNumber ?? "")
        )
    }
}
