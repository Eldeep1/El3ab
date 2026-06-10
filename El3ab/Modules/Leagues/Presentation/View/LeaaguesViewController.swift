//
//  LeaaguesViewController.swift
//  El3ab
//
//  Created by depo on 06/06/2026.
//

import UIKit
import Kingfisher

protocol LeaguesViewProtocol : AnyObject{
    func showData(leagues:[Leagues])
    func showLoading()
    func hideLoading()
    func navigateToDetails(with league: Leagues)
}

class LeaguesViewController: UIViewController {
    
    // Create table view programmatically
    private let leaguesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .bgColor
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let indicator = UIActivityIndicatorView(style: .large)
    var presenter: LeaguesPresenterProtocol?
    var selectedSport: Sport = .football
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupConstraints()
        setupPresenter()
        updateTitle()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        leaguesTableView.register(nib, forCellReuseIdentifier: "LeagueCell")
        leaguesTableView.backgroundColor = .bgColor
        leaguesTableView.separatorStyle = .none
        leaguesTableView.dataSource = self
        leaguesTableView.delegate = self
        
        view.addSubview(leaguesTableView)
        view.backgroundColor = .bgColor
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            leaguesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leaguesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leaguesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            leaguesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupPresenter() {
        self.presenter = LeaguesPresenter()
        presenter?.attachView(self)
        presenter?.loadData(sport: selectedSport)
    }
    
    private func updateTitle() {
        switch selectedSport {
        case .football:
            title = "Football Leagues"
        case .basketball:
            title = "Basketball Leagues"
        case .cricket:
            title = "Cricket Leagues"
        case .tennis:
            title = "Tennis Leagues"
        }
    }
}

extension LeaguesViewController: LeaguesViewProtocol {
    func showData(leagues: [Leagues]) {
        DispatchQueue.main.async {
            self.leaguesTableView.reloadData()
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.indicator.center = self.view.center
            self.view.addSubview(self.indicator)
            self.indicator.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.indicator.removeFromSuperview()
        }
    }
    
    func navigateToDetails(with league: Leagues) {
        
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.barTintColor = .cellColor
        navigationController?.navigationBar.tintColor = .systemGreen
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let leagueDetailsVC = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as? LeagueDetailsViewController {
            leagueDetailsVC.configureSelectedLeague(league: league, sport: selectedSport)
            leagueDetailsVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(leagueDetailsVC, animated: true)
        } else {
            let leagueDetailsVC = LeagueDetailsViewController()
            leagueDetailsVC.configureSelectedLeague(league: league, sport: selectedSport)
            leagueDetailsVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(leagueDetailsVC, animated: true)
        }
    }
}

extension LeaguesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getLeaguesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let league = presenter?.getLeague(index: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as? LeagueTableViewCell else {
            return UITableViewCell()
        }
        
        cell.leagueCountry.text = league.countryName
        cell.leagueTitle.text = league.leagueName
        
        // Load image with Kingfisher
        if let logoURL = league.leagueLogo, !logoURL.isEmpty, let url = URL(string: logoURL) {
            cell.leagueImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "sportscourt"),
                options: [.transition(.fade(0.2))]
            )
        } else {
            cell.leagueImageView.image = UIImage(systemName: "sportscourt")
            cell.leagueImageView.tintColor = .gray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let league = presenter?.getLeague(index: indexPath.row) else { return }
        presenter?.leagueClicked(league: league)
    }
}
