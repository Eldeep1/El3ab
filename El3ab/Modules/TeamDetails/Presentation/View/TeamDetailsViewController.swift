//
//  TeamDetailsViewController.swift
//  El3ab
//

import UIKit
import Kingfisher

class TeamDetailsViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .bgColor
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .bgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let teamHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .bgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let teamLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 60
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.backgroundColor = .systemGray5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let teamNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playersSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .bgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let playersTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Players"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let coachesSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .bgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let coachesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Coaches"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let coachesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let emptyPlayersLabel: UILabel = {
        let label = UILabel()
        label.text = "No players data available"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    

    private var presenter: TeamDetailsPresenter?
    private var team: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionViews()
        setupPresenter()
    }
    
    func configure(with teamId: String, sport: Sport) {
        presenter = TeamDetailsPresenter()
        presenter?.attachView(self)
        presenter?.setTeamId(teamId, sport: sport)
    }
    
    private func setupPresenter() {
        presenter?.fetchTeamDetails()
    }
    
    private func setupUI() {
        view.backgroundColor = .bgColor
        title = "Team Details"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(teamHeaderView)
        teamHeaderView.addSubview(teamLogoImageView)
        teamHeaderView.addSubview(teamNameLabel)
        
        contentView.addSubview(playersSectionView)
        playersSectionView.addSubview(playersTitleLabel)
        playersSectionView.addSubview(playersCollectionView)
        playersSectionView.addSubview(emptyPlayersLabel)
        
        contentView.addSubview(coachesSectionView)
        coachesSectionView.addSubview(coachesTitleLabel)
        coachesSectionView.addSubview(coachesCollectionView)
        
        contentView.addSubview(indicator)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let collectionViewHeight: CGFloat = 200
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            teamHeaderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            teamHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            teamHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            teamLogoImageView.topAnchor.constraint(equalTo: teamHeaderView.topAnchor, constant: 20),
            teamLogoImageView.centerXAnchor.constraint(equalTo: teamHeaderView.centerXAnchor),
            teamLogoImageView.widthAnchor.constraint(equalToConstant: 120),
            teamLogoImageView.heightAnchor.constraint(equalToConstant: 120),
            
            teamNameLabel.topAnchor.constraint(equalTo: teamLogoImageView.bottomAnchor, constant: 16),
            teamNameLabel.leadingAnchor.constraint(equalTo: teamHeaderView.leadingAnchor, constant: 20),
            teamNameLabel.trailingAnchor.constraint(equalTo: teamHeaderView.trailingAnchor, constant: -20),
            teamNameLabel.bottomAnchor.constraint(equalTo: teamHeaderView.bottomAnchor, constant: -20),
            
            playersSectionView.topAnchor.constraint(equalTo: teamHeaderView.bottomAnchor, constant: 20),
            playersSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playersSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            playersTitleLabel.topAnchor.constraint(equalTo: playersSectionView.topAnchor),
            playersTitleLabel.leadingAnchor.constraint(equalTo: playersSectionView.leadingAnchor, constant: 20),
            playersTitleLabel.trailingAnchor.constraint(equalTo: playersSectionView.trailingAnchor, constant: -20),
            
            playersCollectionView.topAnchor.constraint(equalTo: playersTitleLabel.bottomAnchor, constant: 12),
            playersCollectionView.leadingAnchor.constraint(equalTo: playersSectionView.leadingAnchor),
            playersCollectionView.trailingAnchor.constraint(equalTo: playersSectionView.trailingAnchor),
            playersCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
            playersCollectionView.bottomAnchor.constraint(equalTo: playersSectionView.bottomAnchor),
            
            emptyPlayersLabel.centerXAnchor.constraint(equalTo: playersCollectionView.centerXAnchor),
            emptyPlayersLabel.centerYAnchor.constraint(equalTo: playersCollectionView.centerYAnchor),
            
            coachesSectionView.topAnchor.constraint(equalTo: playersSectionView.bottomAnchor, constant: 30),
            coachesSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coachesSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coachesSectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            coachesTitleLabel.topAnchor.constraint(equalTo: coachesSectionView.topAnchor),
            coachesTitleLabel.leadingAnchor.constraint(equalTo: coachesSectionView.leadingAnchor, constant: 20),
            coachesTitleLabel.trailingAnchor.constraint(equalTo: coachesSectionView.trailingAnchor, constant: -20),
            
            coachesCollectionView.topAnchor.constraint(equalTo: coachesTitleLabel.bottomAnchor, constant: 12),
            coachesCollectionView.leadingAnchor.constraint(equalTo: coachesSectionView.leadingAnchor),
            coachesCollectionView.trailingAnchor.constraint(equalTo: coachesSectionView.trailingAnchor),
            coachesCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
            coachesCollectionView.bottomAnchor.constraint(equalTo: coachesSectionView.bottomAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCollectionViews() {
        playersCollectionView.delegate = self
        playersCollectionView.dataSource = self
        playersCollectionView.register(TeamMemberCell.self, forCellWithReuseIdentifier: TeamMemberCell.identifier)
        
        coachesCollectionView.delegate = self
        coachesCollectionView.dataSource = self
        coachesCollectionView.register(TeamMemberCell.self, forCellWithReuseIdentifier: TeamMemberCell.identifier)
    }
    
    private func displayTeamInfo() {
        guard let team = team else { return }
        
        teamNameLabel.text = team.name
        
        if !team.logoImageName.isEmpty, let url = URL(string: team.logoImageName) {
            teamLogoImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "sportscourt"))
        } else {
            teamLogoImageView.image = UIImage(systemName: "sportscourt")
            teamLogoImageView.tintColor = .gray
        }
        
        let hasPlayers = !team.players.isEmpty
        playersCollectionView.isHidden = !hasPlayers
        emptyPlayersLabel.isHidden = hasPlayers
        
        let hasCoaches = !team.coaches.isEmpty
        coachesSectionView.isHidden = !hasCoaches
        
        playersCollectionView.reloadData()
        coachesCollectionView.reloadData()
    }
}

extension TeamDetailsViewController: TeamDetailsViewProtocol {
    func showLoading() {
        DispatchQueue.main.async {
            self.indicator.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
        }
    }
    
    func showTeamDetails(_ team: Team) {
        self.team = team
        displayTeamInfo()
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            self.present(alert, animated: true)
        }
    }
}

extension TeamDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == playersCollectionView {
            return team?.players.count ?? 0
        } else if collectionView == coachesCollectionView {
            return team?.coaches.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TeamMemberCell.identifier,
            for: indexPath
        ) as? TeamMemberCell else {
            return UICollectionViewCell()
        }
        
        if collectionView == playersCollectionView {
            if let player = team?.players[indexPath.item] {
                cell.configure(with: player)
            }
        } else if collectionView == coachesCollectionView {
            if let coach = team?.coaches[indexPath.item] {
                cell.configure(with: coach)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 180)
    }
}
