//
//  LeagueResponse.swift
//  El3ab
//

import Foundation

struct LeagueResponse: Codable {
    let success: Int?
    let result: [LeagueAPI]?
    
    enum CodingKeys: String, CodingKey {
        case success
        case result
    }
}

struct LeagueAPI: Codable {
    let leagueKey: Int
    let leagueName: String
    let countryKey: Int
    let countryName: String
    let leagueLogo: String?
    let countryLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryKey = "country_key"
        case countryName = "country_name"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
    }
    
    func toLeague() -> Leagues {
        return Leagues(
            leagueKey: leagueKey,
            leagueName: leagueName,
            countryName: countryName,
            leagueLogo: leagueLogo ?? "",
            countryLogo: countryLogo,
            sportName: ""
        )
    }
}
