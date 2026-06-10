// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let eventResponse = try? JSONDecoder().decode(EventResponse.self, from: jsonData)

import Foundation

struct EventResponse: Codable {
    let success: Int
    let result: [EventAPI]?
}

struct EventAPI: Codable {
    let eventKey,awayTeamKey, homeTeamKey,leagueKey: Int
    let eventDate, eventTime, eventHomeTeam: String
    let  eventAwayTeam, eventHalftimeResult: String
    let eventFinalResult, eventStatus, countryName, leagueName: String
    let leagueRound, leagueSeason, eventLive: String
    let eventStadium, eventReferee: String
    let homeTeamLogo, awayTeamLogo: String
    let leagueLogo: String

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case homeTeamKey = "home_team_key"
        case eventAwayTeam = "event_away_team"
        case awayTeamKey = "away_team_key"
        case eventHalftimeResult = "event_halftime_result"
        case eventFinalResult = "event_final_result"
        case eventStatus = "event_status"
        case countryName = "country_name"
        case leagueName = "league_name"
        case leagueKey = "league_key"
        case leagueRound = "league_round"
        case leagueSeason = "league_season"
        case eventLive = "event_live"
        case eventStadium = "event_stadium"
        case eventReferee = "event_referee"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case leagueLogo = "league_logo"
    }
    func toEvent()-> Event {
        return Event(
            eventDate: self.eventDate,
            eventTime: self.eventTime,
            homeTeamName: self.eventHomeTeam,
            enemyTeamName: self.eventAwayTeam, // Maps eventAwayTeam to enemyTeamName
            finalResult: self.eventFinalResult,
            homeTeamLogo: self.homeTeamLogo,
            awayTeamLogo: self.awayTeamLogo
        )
    }
}
