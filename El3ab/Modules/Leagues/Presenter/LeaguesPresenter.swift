//
//  LeaguesPresenter.swift
//  El3ab
//
//  Created by depo on 06/06/2026.
//

import Foundation

protocol LeaguesPresenterProtocol{
    func loadData()
    func leagueClickd(_ leagueKey:Int)
}

class LeaguesPresenter : LeaguesPresenterProtocol{
    weak var view : LeaguesViewProtocol?
    var data:[Leagues]=[
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
    ]
    func loadData() {
        view?.showLoading()
        //do the api call
        //how will we handle the errors?
        //like view.showError()
        view?.showData(leagues: data)
        view?.hideLoading()
    }
    
    func leagueClickd(_ leagueKey: Int) {
        
    }
    
    
}
