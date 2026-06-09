//
//  LeagueDetailsPresenter.swift
//  El3ab
//
//  Created by depo on 08/06/2026.
//

import Foundation

protocol LeagueDetailsPresenterProtocol{
    func addToFavourite(leageu:Leagues)
    func navigateToTeamDetails()
    func reloadData()
    func configureSelectedLeague(league: Leagues, sport: Sport)
    func getUpComingEventsCount()->Int
    func getUpComingEvent(index at:Int)
    func getLatestEventsCount()->Int
    func getLatestEvent(index at:Int)
    func getTeamsCount()->Int
    func getTeam(index at:Int)
}
class LeagueDetailsPresenter {
    weak var view: LeagueDetailsViewControllerProtocol?
    private var teams: [Team] = []
    
    func didSelectTeam(at index: Int, teamId: String, sport: Sport) {
        view?.navigateToTeamDetails(with: teamId, sport: sport)
    }
    
    
}
