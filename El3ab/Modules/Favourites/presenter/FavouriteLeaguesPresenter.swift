//
//  FavouriteLeaguesPresenter.swift
//  El3ab
//
//  Created by depo on 07/06/2026.
//

import Foundation

protocol FavouriteLeaguesPresenterProtocol{
    func getFavouritesCount()->Int
    func getFavouriteLeagueItem(index:Int)->Leagues
    func removeFavourite(at index : Int)
    func leagueDetails(at index : Int)
}

class FavouriteLeaguesPresenter : FavouriteLeaguesPresenterProtocol{
    
    var view : FavouriteLeaguesViewProtocol?
    var data:[Leagues]?

    init(view: FavouriteLeaguesViewProtocol? = nil) {
        self.view = view
        getFavourites()
    }
    
    func getFavourites(){
        //fetch it from core data
        data = [
            Leagues(
                leagueKey: 3,
                leagueName: "UEFA Champions League",
                countryName: "eurocups",
                leagueLogo: "https://allsportsapi.com3_uefa_champions_league.png",
                countryLogo: nil
            ),
            Leagues(
                leagueKey: 3,
                leagueName: "UEFA Champions League",
                countryName: "eurocups",
                leagueLogo: "https://allsportsapi.com3_uefa_champions_league.png",
                countryLogo: nil
            ),
            Leagues(
                leagueKey: 3,
                leagueName: "UEFA Champions Leagueeeeeeeeeeeeeeeeee",
                countryName: "eurocups",
                leagueLogo: "https://allsportsapi.com3_uefa_champions_league.png",
                countryLogo: nil
            ),
            Leagues(
                leagueKey: 3,
                leagueName: "UEFA Champions League",
                countryName: "eurocups",
                leagueLogo: "https://allsportsapi.com3_uefa_champions_league.png",
                countryLogo: nil
            ),
        ]
        
        view?.reloadFavourites()
    }
    func getFavouritesCount() -> Int {
        data?.count ?? 0
    }
    
    func getFavouriteLeagueItem(index: Int) -> Leagues {
        data![index]
    }
    
    
    
    
    func removeFavourite(at index: Int) {
        // show warnning and do some core data logic
        data?.remove(at: index)
        view?.reloadFavourites()
    }
    
    func leagueDetails(at index: Int) {
        // call the navigation function from the UI
    }
    
    
}
