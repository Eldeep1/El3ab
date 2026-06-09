//
//  TeamResponse.swift
//  El3ab
//

import Foundation

struct TeamResponse: Codable {
    let success: Int
    let result: [TeamAPI]
    
    enum CodingKeys: String, CodingKey {
        case success
        case result
    }
}

struct TeamAPI: Codable {
    let teamKey: Int
    let teamName: String
    let teamLogo: String?
    let players: [PlayerAPI]?
    let coaches: [CoachAPI]?
    
    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case players = "players"
        case coaches = "coaches"
    }
    
    func toTeam() -> Team {
        let playerList = players?.map { $0.toPlayer() } ?? []
        let coachList = coaches?.map { $0.toCoach() } ?? []
        
        return Team(
            name: teamName,
            logoImageName: teamLogo ?? "",
            players: playerList,
            coaches: coachList
        )
    }
}

struct PlayerAPI: Codable {
    let playerKey: Int?
    let playerImage: String?
    let playerName: String
    let playerNumber: String?
    let playerType: String?
    let playerAge: String?
    let playerMatchPlayed: String?
    let playerGoals: String?
    let playerYellowCards: String?
    let playerRedCards: String?
    let playerCountry: String?
    let playerInjured: String?
    let playerBirthdate: String?
    let playerRating: String?
    
    enum CodingKeys: String, CodingKey {
        case playerKey = "player_key"
        case playerImage = "player_image"
        case playerName = "player_name"
        case playerNumber = "player_number"
        case playerType = "player_type"
        case playerAge = "player_age"
        case playerMatchPlayed = "player_match_played"
        case playerGoals = "player_goals"
        case playerYellowCards = "player_yellow_cards"
        case playerRedCards = "player_red_cards"
        case playerCountry = "player_country"
        case playerInjured = "player_injured"
        case playerBirthdate = "player_birthdate"
        case playerRating = "player_rating"
    }
    
    func toPlayer() -> Player {
        var positionText = playerType ?? ""
        if let rating = playerRating, !rating.isEmpty {
            positionText += " ★\(rating)"
        }
        
        return Player(
            name: playerName,
            imageName: playerImage ?? "",
            position: positionText,
            number: Int(playerNumber ?? "")
        )
    }
}

struct CoachAPI: Codable {
    let coachName: String?
    let coachCountry: String?
    let coachAge: String?
    
    enum CodingKeys: String, CodingKey {
        case coachName = "coach_name"
        case coachCountry = "coach_country"
        case coachAge = "coach_age"
    }
    
    func toCoach() -> Coach {
        return Coach(
            name: coachName ?? "Unknown",
            imageName: "",
            role: "Coach"
        )
    }
}
