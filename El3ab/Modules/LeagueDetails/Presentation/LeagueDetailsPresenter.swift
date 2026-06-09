//
//  LeagueDetailsPresenter.swift
//  El3ab
//
//  Created by depo on 08/06/2026.
//

import Foundation

class LeagueDetailsPresenter {
    weak var view: LeagueDetailsViewControllerProtocol?
    private var teams: [Team] = []
    
    func didSelectTeam(at index: Int, teamId: String, sport: Sport) {
        view?.navigateToTeamDetails(with: teamId, sport: sport)
    }
}
