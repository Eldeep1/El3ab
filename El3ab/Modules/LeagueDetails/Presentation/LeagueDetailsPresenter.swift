//
//  LeagueDetailsPresenter.swift
//  El3ab
//
//  Created by depo on 08/06/2026.
//

import Foundation

protocol LeagueDetailsPresenterProtocol{
    func addToFavourite(leageu:Leagues)
    func didSelectTeam(at index:Int) //used
    func getEvents()
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
    
    init(view: LeagueDetailsViewControllerProtocol, sport: Sport, league: Leagues, networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.view = view
        self.sport = sport
        self.league = league
        self.networkService=networkService
        
    }
    func getEvents(){
        view?.showLoading()
        
        guard let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: today),
              let thirtyDaysHence = calendar.date(byAdding: .day, value: 30, to: today) else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let fromString = formatter.string(from: thirtyDaysAgo)
        let toString = formatter.string(from: thirtyDaysHence)
        
        networkService.fetchEventDetails(
            sport: sport,
            leagueId: String(league.leagueKey),
            from: fromString,
            to: toString
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let allEvents):
                let rightNow = Date()
                
                upComingEvents = allEvents
                    .filter { formatter.date(from: $0.eventDate ?? "") ?? rightNow >= rightNow }
                    .sorted { $0.eventDate ?? "" < $1.eventDate ?? "" }
                
                pastEvents = allEvents
                    .filter { formatter.date(from: $0.eventDate ?? "") ?? rightNow  < rightNow }
                    .sorted { $0.eventDate ?? "" > $1.eventDate ?? "" }
                
                DispatchQueue.main.async {
                    self.view?.hideLoading()
                    self.view?.showData()
                    
                }
                
            case .failure(let error):
                print("Error fetching events: \(error)")
                // Handle UI error state
            }
        }
    }
    
    
    func addToFavourite(leageu: Leagues) {
        //need core data, so will deny it for now
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
