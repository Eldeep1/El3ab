//
//  LeagueDetailsPresenter.swift
//  El3ab
//
//  Created by depo on 08/06/2026.
//

import Foundation
class LeagueDetailsPresenter{
    weak var view: LeagueDetailsViewControllerProtocol?
        private var teams: [Team] = []
        
        
        func didSelectTeam(at index: Int) {
            guard index < teams.count else { return }
            let selectedTeam = teams[index]
            
            
            view?.navigateToTeamDetails(with: selectedTeam)
        }
}
