//
//  FavouriteLeaguesViewController.swift
//  El3ab
//
//  Created by depo on 07/06/2026.
//

import UIKit
import Alamofire
protocol FavouriteLeaguesViewProtocol{
    func reloadFavourites()
    func showInternetError()
    
}

class FavouriteLeaguesViewController: UIViewController {
    
    @IBOutlet weak var leaguesTableView: UITableView!
    let indicator = UIActivityIndicatorView(style: .large)
    
    var presenter:FavouriteLeaguesPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = FavouriteLeaguesPresenter(view: self)
        
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        
        leaguesTableView.register(nib, forCellReuseIdentifier: "LeagueCell")
        leaguesTableView.backgroundColor = .bgColor
        self.view.backgroundColor = .bgColor
        title = "My Leagues"
        leaguesTableView.separatorStyle = .none
        leaguesTableView.dataSource = self
        leaguesTableView.delegate = self
        AF.request("https://httpbin.org/get").response { response in
                    if let statusCode = response.response?.statusCode {
                        print("✅ Alamofire is working! Status code: \(statusCode)")
                    } else if let error = response.error {
                        print("❌ Alamofire request failed: \(error.localizedDescription)")
                    }
                }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//      Get the new view controller using segue.destination.
//      Pass the selected object to the new view controller.
        if segue.identifier == "FavouritesLeaguesToLeagueDetails" {
            let LeagueDetailsVC = segue.destination as! LeagueDetailsViewController
            if let league = sender as? Leagues {
                LeagueDetailsVC.configureSelectedLeague(league: league)
            }
        }
    }
}

extension FavouriteLeaguesViewController :FavouriteLeaguesViewProtocol{
    func reloadFavourites() {
        leaguesTableView.reloadData()
    }
    
    func showInternetError() {
        //TODO: show alert Dialoguge
    }
}

extension FavouriteLeaguesViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return presenter?.getFavouritesCount() ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let league = presenter?.getFavouriteLeagueItem(index: indexPath.row)
         let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueTableViewCell
            
        cell.leagueCountry.text = league?.countryName
//        cell.leagueImageView =
        cell.leagueTitle.text=league?.leagueName
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let league = presenter?.getFavouriteLeagueItem(index: indexPath.row)
        performSegue(withIdentifier: "FavouritesLeaguesToLeagueDetails", sender: league)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler:{
            [weak self](action, view, completionHandler) in
            
            let alert = UIAlertController(title: "Delete League", message: "Are You Sure You Want To Delete This League From Favourites?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                _ in completionHandler(false)
            })
            
            let confirmAction = UIAlertAction(title: "Delte", style: .destructive, handler: {_ in
                self?.presenter?.removeFavourite(at: indexPath.row)
                completionHandler(true)
            })
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            
            self?.present(alert,animated: true,completion: nil)
            
        } )
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
        
    }
    
    
}

