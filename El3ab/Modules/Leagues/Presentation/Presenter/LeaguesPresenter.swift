//
//  LeaguesPresenter.swift
//  El3ab
//
//  Created by depo on 06/06/2026.
//

import Foundation

protocol LeaguesPresenterProtocol {
    func loadData(sport: Sport)
    func leagueClicked(league: Leagues)
    func attachView(_ view: LeaguesViewProtocol)
    func getLeaguesCount() -> Int
    func getLeague(index: Int) -> Leagues
}

class LeaguesPresenter : LeaguesPresenterProtocol {
    
    weak var view : LeaguesViewProtocol?
    var data: [Leagues] = []
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func getLeague(index: Int) -> Leagues {
        return data[index]
    }
    
    func getLeaguesCount() -> Int {
        return data.count
    }
    
    func attachView(_ view: LeaguesViewProtocol) {
        self.view = view
    }
    
    func loadData(sport: Sport) {
        view?.showLoading()
        
        networkService.fetchLeagues(sport: sport) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                
                switch result {
                case .success(let leagues):
                    self?.data = leagues
                    self?.view?.showData(leagues: leagues)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self?.view?.showData(leagues: [])
                    
                }
            }
        }
    }
    
    func leagueClicked(league: Leagues) {
        view?.navigateToDetails(with: league)
    }
}
