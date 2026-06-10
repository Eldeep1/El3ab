//
//  FavouriteLeaguesPresenter.swift
//  El3ab
//

import Foundation

protocol FavouriteLeaguesPresenterProtocol {
    func getFavouritesCount() -> Int
    func getFavouriteLeagueItem(index: Int) -> Leagues
    func removeFavourite(at index: Int)
    func leagueDetails(at index: Int)
}

class FavouriteLeaguesPresenter : FavouriteLeaguesPresenterProtocol{
    
    weak var view : FavouriteLeaguesViewProtocol?
    var data: [Leagues]?
    private let coreDataManager = CoreDataManager.shared

    init(view: FavouriteLeaguesViewProtocol? = nil) {
        self.view = view
        loadFavourites()
    }
    
    func loadFavourites() {  
        data = coreDataManager.getAllFavoriteLeagues()
        view?.reloadFavourites()
    }
    
    func getFavouritesCount() -> Int {
        data?.count ?? 0
    }
    
    func getFavouriteLeagueItem(index: Int) -> Leagues {
        guard let data = data, index < data.count else {
            fatalError("Index out of range")
        }
        return data[index]
    }
    
    func removeFavourite(at index: Int) {
        guard let league = data?[index] else { return }
        
        let success = coreDataManager.deleteFavoriteLeague(leagueKey: league.leagueKey)
        
        if success {
            data?.remove(at: index)
            view?.reloadFavourites()
        }
    }
    
    func leagueDetails(at index: Int) {
        // This will be handled by the view controller
    }
}
