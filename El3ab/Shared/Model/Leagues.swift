//
//  Leagues.swift
//  El3ab
//
//  Created by Osama Khaled on 09/06/2026.
//

import Foundation

struct Leagues {
    let leagueKey: Int
    let leagueName: String
    let countryName: String
    let leagueLogo: String?
    let countryLogo: String?
    let sportName: String? 
}

extension Leagues {
    static var sampleLeagues: [Leagues] {
        return [
            Leagues(
                leagueKey: 3,
                leagueName: "UEFA Champions League",
                countryName: "Europe",
                leagueLogo: "https://media.api-sports.io/football/leagues/2.png",
                countryLogo: "https://media.api-sports.io/flags/eu.svg",
                sportName: "football"
            ),
            Leagues(
                leagueKey: 4,
                leagueName: "English Premier League",
                countryName: "England",
                leagueLogo: "https://media.api-sports.io/football/leagues/39.png",
                countryLogo: "https://media.api-sports.io/flags/gb.svg",
                sportName: "football"
            ),
            Leagues(
                leagueKey: 5,
                leagueName: "La Liga",
                countryName: "Spain",
                leagueLogo: "https://media.api-sports.io/football/leagues/140.png",
                countryLogo: "https://media.api-sports.io/flags/es.svg",
                sportName: "football"
            ),
            Leagues(
                leagueKey: 6,
                leagueName: "Serie A",
                countryName: "Italy",
                leagueLogo: "https://media.api-sports.io/football/leagues/135.png",
                countryLogo: "https://media.api-sports.io/flags/it.svg",
                sportName: "football"
            ),
            Leagues(
                leagueKey: 7,
                leagueName: "Bundesliga",
                countryName: "Germany",
                leagueLogo: "https://media.api-sports.io/football/leagues/78.png",
                countryLogo: "https://media.api-sports.io/flags/de.svg",
                sportName: "football"
            ),
            Leagues(
                leagueKey: 8,
                leagueName: "Ligue 1",
                countryName: "France",
                leagueLogo: "https://media.api-sports.io/football/leagues/61.png",
                countryLogo: "https://media.api-sports.io/flags/fr.svg",
                sportName: "football"
            )
        ]
    }
}
