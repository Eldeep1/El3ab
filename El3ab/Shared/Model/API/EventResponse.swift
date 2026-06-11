

import Foundation

struct EventResponse: Codable {
    let success: Int
    let result: [EventAPI]?
}
struct EventAPI: Codable {
    let eventKey: Int?
    let awayTeamKey: Int?
    let homeTeamKey: Int?
    let leagueKey: Int?

    let eventDate: String?
    let eventTime: String?
    let eventHomeTeam: String?
    let eventAwayTeam: String?
    let eventHalftimeResult: String?
    let eventFinalResult: String?
    let eventStatus: String?
    let countryName: String?
    let leagueName: String?
    let leagueRound: String?
    let leagueSeason: String?
    let eventLive: String?
    let eventStadium: String?
    let eventReferee: String?

    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let leagueLogo: String?

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

    func toEvent() -> Event {
        Event(
            eventDate: eventDate ?? "",
            eventTime: eventTime ?? "",
            homeTeamName: eventHomeTeam ?? "",
            enemyTeamName: eventAwayTeam ?? "",
            finalResult: eventFinalResult ?? "",
            homeTeamLogo: homeTeamLogo ?? "",
            awayTeamLogo: awayTeamLogo ?? ""
        )
    }
}
