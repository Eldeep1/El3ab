//
//  LeagueDetailsPresenter.swift
//  El3ab
//
//  Created by depo on 08/06/2026.
//

import Foundation

protocol LeagueDetailsPresenterProtocol{
    func addToFavourite()
    func didSelectTeam(at index:Int) //used
    func fetchLeagueData()
    func getUpComingEventsCount()->Int
    func getUpComingEvent(at index:Int) -> Event
    func getLatestEventsCount()->Int
    func getLatestEvent(at index:Int) -> Event
    func getTeamsCount()->Int
    func getTeam(at index:Int)->Team
}
class LeagueDetailsPresenter : LeagueDetailsPresenterProtocol {
    
    private weak var view: LeagueDetailsViewControllerProtocol?
    private var teams: [Team] = []
    private var upComingEvents: [Event] = []
    private var pastEvents: [Event]=[]
    private var sport:Sport
    private var league:Leagues
    private let networkService: NetworkServiceProtocol
    private let today = Date()
    private let calendar = Calendar.current
    private let localDataStorage : LocalStorageProtocol

    init(view: LeagueDetailsViewControllerProtocol, sport: Sport, league: Leagues, networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.view = view
        self.sport = sport
        self.league = league
        self.networkService=networkService
        localDataStorage =  CoreDataManager.shared
    }
    
    func fetchLeagueData() {

        view?.showLoading()

        guard let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: today),
              let upComingDays = calendar.date(byAdding: .day, value: 100, to: today)
        else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let fromString = formatter.string(from: thirtyDaysAgo)
        let toString = formatter.string(from: upComingDays)

        let group = DispatchGroup()

        var eventsError: Error?
        var teamsError: Error?

        group.enter()

        networkService.fetchEventDetails(
            sport: sport,
            leagueId: String(league.leagueKey),
            from: fromString,
            to: toString
        ) { [weak self] result in

            defer { group.leave() }

            guard let self = self else { return }
            switch result {

            case .success(let allEvents):

                let rightNow = Date()

                self.upComingEvents = allEvents
                    .filter {
                        formatter.date(from: $0.eventDate ?? "") ?? rightNow >= rightNow
                    }

                self.pastEvents = allEvents
                    .filter {
                        formatter.date(from: $0.eventDate ?? "") ?? rightNow < rightNow
                    }

            case .failure(let error):
                eventsError = error
            }
        }

        // TEAMS
        group.enter()

        networkService.fetchLeagueTeams(
            sport: sport,
            leagueId: String(league.leagueKey)
        ) { [weak self] result in

            defer { group.leave() }

            guard let self = self else { return }
            switch result {

            case .success(let teams):
                self.teams = teams

            case .failure(let error):
                teamsError = error
            }
        }

        group.notify(queue: .main) { [weak self] in

            guard let self = self else { return }
            self.view?.hideLoading()

            if let error = eventsError ?? teamsError {
                print(error)
//                self.view?.showError(error.localizedDescription)
                return
            }

            self.view?.showData()
        }
    }
    
    
    func addToFavourite() {
        if localDataStorage.addFavoriteLeague(league: league, sportName: sport.rawValue) == true{
            view?.addToFavourite()
        }
        else{
            view?.existsInVafourite()
        }
    }
    
    
    
    func getUpComingEventsCount() -> Int {
        upComingEvents.count
    }
    
    func getUpComingEvent(at index: Int) -> Event {
        upComingEvents[index]
    }
    
    func getLatestEventsCount() -> Int {
        pastEvents.count
    }
    
    func getLatestEvent(at index: Int) -> Event {
        pastEvents[index]
    }
    
    func getTeamsCount() -> Int {
        teams.count
    }
    
    func getTeam(at index: Int) ->Team {
        teams[index]
    }
    
    
    func didSelectTeam(at index: Int) {
        let team = teams[index]
        view?.navigateToTeamDetails(with: String(team.teamID), sport: sport)
    }
    
}
