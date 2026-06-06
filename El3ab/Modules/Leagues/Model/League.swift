//
//  League.swift
//  El3ab
//
//  Created by depo on 06/06/2026.
//

import Foundation

struct LeaguesResponse:Decodable{
    var result:[Leagues]
}

struct Leagues:Decodable{
    
    let leagueKey: Int
    
    let leagueName: String
    let countryName: String
    let leagueLogo: String?
    let countryLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryName = "country_name"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
    }
}
