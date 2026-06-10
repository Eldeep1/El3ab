//
//  FavouriteLeaguesViewController.swift
//  El3ab
//

import UIKit
import Network

protocol FavouriteLeaguesViewProtocol: AnyObject {
    func reloadFavourites()
    func showInternetError()
    func showSuccessMessage(message: String)
    func showErrorMessage(message: String)
}

class FavouriteLeaguesViewController: UIViewController {
    
    @IBOutlet weak var leaguesTableView: UITableView!
    let indicator = UIActivityIndicatorView(style: .large)
    
    var presenter: FavouriteLeaguesPresenter?
    private let monitor = NWPathMonitor()
    private var isConnected = true
    
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
        
        startMonitoringNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.loadFavourites()
    }
    
    private func startMonitoringNetwork() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    private func checkInternetAndNavigate(league: Leagues) {
        if isConnected {
            let leaguesDetailsVC =
            storyboard?.instantiateViewController(
                withIdentifier: "LeagueDetailsViewController"
            ) as! LeagueDetailsViewController
            let sport = getSportEnum(from: league.sportName)
            leaguesDetailsVC.configureSelectedLeague(league: league, sport: sport)
            leaguesDetailsVC.hidesBottomBarWhenPushed = true
            navigationItem.backButtonDisplayMode = .minimal
            navigationController?.navigationBar.barTintColor = .cellColor
            navigationController?.navigationBar.tintColor = .systemGreen

            navigationController?.pushViewController(leaguesDetailsVC, animated: true)
        } else {
            showNoInternetAlert()
        }
    }
    
    private func showNoInternetAlert() {
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your internet connection and try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    private func getSportEnum(from sportName: String?) -> Sport {
        guard let sportName = sportName else { return .football }
        
        switch sportName.lowercased() {
        case "football":
            return .football
        case "basketball":
            return .basketball
        case "tennis":
            return .tennis
        case "cricket":
            return .cricket
        default:
            return .football
        }
    }
}

extension FavouriteLeaguesViewController: FavouriteLeaguesViewProtocol {
    func reloadFavourites() {
        leaguesTableView.reloadData()
        
        if presenter?.getFavouritesCount() == 0 {
            showEmptyState()
        } else {
            removeEmptyState()
        }
    }
    
    func showInternetError() {
        let alert = UIAlertController(
            title: "Network Error",
            message: "Please check your internet connection and try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccessMessage(message: String) {
        let alert = UIAlertController(
            title: "Success",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showErrorMessage(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showEmptyState() {
        let emptyLabel = UILabel()
        emptyLabel.text = "No favorite leagues yet.\nAdd some from the leagues screen!"
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .gray
        emptyLabel.font = .systemFont(ofSize: 16)
        leaguesTableView.backgroundView = emptyLabel
    }
    
    private func removeEmptyState() {
        leaguesTableView.backgroundView = nil
    }
}

extension FavouriteLeaguesViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.leagueTitle.text = league?.leagueName
        if let logoUrl = league?.leagueLogo, let url = URL(string: logoUrl) {
            cell.leagueImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "sportscourt"),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            ) { result in
                switch result {
                case .success:
                    break
                case .failure:
                    cell.leagueImageView.image = UIImage(systemName: "sportscourt")
                    cell.leagueImageView.tintColor = .gray
                }
            }
        } else {
            cell.leagueImageView.image = UIImage(systemName: "sportscourt")
            cell.leagueImageView.tintColor = .gray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let league = presenter?.getFavouriteLeagueItem(index: indexPath.row) else { return }
        
        checkInternetAndNavigate(league: league)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            
            let alert = UIAlertController(
                title: "Delete League",
                message: "Are you sure you want to delete this league from favorites?",
                preferredStyle: .alert
            )
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                completionHandler(false)
            }
            
            let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                self?.presenter?.removeFavourite(at: indexPath.row)
                completionHandler(true)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            
            self?.present(alert, animated: true)
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}
