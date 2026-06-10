//
//  TeamDetailsPresenter.swift
//  El3ab
//
//  Created by Osama Khaled on 10/06/2026.
//

import Foundation

protocol TeamDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showTeamDetails(_ team: Team)
    func showError(_ message: String)
}

class TeamDetailsPresenter {
    private weak var view: TeamDetailsViewProtocol?
    private let networkService: NetworkServiceProtocol
    private var teamId: String?
    private var sport: Sport?
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func attachView(_ view: TeamDetailsViewProtocol) {
        self.view = view
    }
    
    func setTeamId(_ teamId: String, sport: Sport) {
        self.teamId = teamId
        self.sport = sport
    }
    
    func fetchTeamDetails() {
        guard let teamId = teamId, let sport = sport else {
            view?.showError("Team information missing")
            return
        }
        
        view?.showLoading()
        
        networkService.fetchTeamDetails(sport: sport, teamId: teamId) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                
                switch result {
                case .success(let team):
                    self?.view?.showTeamDetails(team)
                case .failure(let error):
                    self?.view?.showError("Failed to load team details: \(error.localizedDescription)")
                }
            }
        }
    }
}
