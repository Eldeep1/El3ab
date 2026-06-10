//
//  LeagueDetailsViewController.swift
//  El3ab
//
//  Created by depo on 07/06/2026.
//

import UIKit
import Alamofire

protocol LeagueDetailsViewControllerProtocol: AnyObject {
    func navigateToTeamDetails(with teamId: String, sport: Sport)
    func addToFavourite()
    func showData()
    func showLoading()
    func hideLoading()
    func removeFromFavourite()
    func showDeleteConfirmation()
    func updateFavouriteButton(isFavourite: Bool)
}
class LeagueDetailsViewController: UIViewController {
    
    var presenter:LeagueDetailsPresenterProtocol?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    @IBOutlet weak var collectionView: UICollectionView!
    private var visibleSections: [LeagueSections] = []
    func configureSelectedLeague(league: Leagues, sport: Sport) {
        presenter = LeagueDetailsPresenter(view:self , sport: sport, league: league)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let favouriteButton = UIBarButtonItem(image: UIImage(systemName: "heart") , style: UIBarButtonItem.Style.plain, target: self, action: #selector (favouriteTapped))
        navigationItem.rightBarButtonItem = favouriteButton
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.view.backgroundColor = .bgColor
        self.collectionView.backgroundColor = .bgColor
        collectionView.collectionViewLayout = createCompositionalLayout()
        collectionView.register(UINib(nibName: "UpComingEventsViewCell", bundle: nil), forCellWithReuseIdentifier: "UpComingEventsViewCell")
            collectionView.register(UINib(nibName: "LatestEventsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LatestEventsCollectionViewCell")
            collectionView.register(UINib(nibName: "TeamsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TeamsCollectionViewCell")

        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier
        )
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        view.addSubview(activityIndicator)
        presenter?.fetchLeagueData()
        presenter?.checkIfFavourite()
        navigationItem.title = presenter?.getLeagueName()
    }
    @objc func favouriteTapped(){
        presenter?.addToFavourite()
    }
    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let sectionType = visibleSections[sectionIndex]
            
            switch sectionType {
            case .upcomingEvents:
                return self.createUpcomingEventsSection()
            case .latestEvents:
                return self.createLatestEventsSection()
            case .teams:
                return self.createTeamsSection()
            }
        }
        
    }
    private func createUpcomingEventsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(180), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 24, trailing: 16)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createLatestEventsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 24, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        section.boundarySupplementaryItems = [header]
        return section
    }
    private func createTeamsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 16, trailing: 16)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        section.boundarySupplementaryItems = [header]
        
        return section
    }
}

extension LeagueDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section==visibleSections.count-1){
            presenter?.didSelectTeam(at: indexPath.item)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         let sectionType = visibleSections[section]
        switch sectionType {
        case .upcomingEvents: return presenter?.getUpComingEventsCount() ?? 0
        case .latestEvents: return presenter?.getLatestEventsCount() ?? 0
        case .teams: return presenter?.getTeamsCount() ?? 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let sectionType = visibleSections[indexPath.section]
        
        switch sectionType {
        case .upcomingEvents:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpComingEventsViewCell", for: indexPath) as! UpComingEventsViewCell
            
            if let model = presenter?.getUpComingEvent(at: indexPath.item) {
                        cell.configure(event: model)
                    } else {
                        print("No event data found for item index: \(indexPath.item)")
                    }
            
            return cell
            
        case .latestEvents:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestEventsCollectionViewCell", for: indexPath) as! LatestEventsCollectionViewCell
            if let model :Event = presenter?.getLatestEvent(at:indexPath.item){
                cell.configure(event: model)

            }else{
                print("another empty one here....")
            }
            return cell
            
        case .teams:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamsCollectionViewCell", for: indexPath) as! TeamsCollectionViewCell
            if let model:Team = presenter?.getTeam(at: indexPath.item){
                cell.configure(team: model)}
            else{
                print("the presenter is empty as your heart");
            }
            return cell
        }
    }
}
extension LeagueDetailsViewController {

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.identifier,
            for: indexPath
        ) as! SectionHeaderView

        switch visibleSections[indexPath.section] {
        case .upcomingEvents:
            header.titleLabel.text = "Upcoming Events"

        case .latestEvents:
            header.titleLabel.text = "Latest Events"

        case .teams:
            header.titleLabel.text = "Teams"
        }

        return header
    }
}
extension LeagueDetailsViewController: LeagueDetailsViewControllerProtocol {
    func updateFavouriteButton(isFavourite: Bool) {

        let imageName = isFavourite
            ? "heart.fill"
            : "heart"

        let favouriteButton = UIBarButtonItem(
            image: UIImage(systemName: imageName),
            style: .plain,
            target: self,
            action: #selector(favouriteTapped)
        )

        navigationItem.rightBarButtonItem = favouriteButton
    }
    func showDeleteConfirmation() {
        let alert = UIAlertController(
               title: "Delete League",
               message: "Are you sure you want to delete this league from favorites?",
               preferredStyle: .alert
           )

           let cancelAction = UIAlertAction(
               title: "Cancel",
               style: .cancel
           )

           let confirmAction = UIAlertAction(
               title: "Delete",
               style: .destructive
           ) {  _ in
               self.presenter?.confirmDeleteLeague()
           }

           alert.addAction(cancelAction)
           alert.addAction(confirmAction)

           present(alert, animated: true)

    }
    
    func addToFavourite() {

        updateFavouriteButton(isFavourite: true)

        showToast(
            message: "Added To Favourites",
            font: .systemFont(ofSize: 14.0)
        )
    }

    func removeFromFavourite() {

        updateFavouriteButton(isFavourite: false)

        showToast(
            message: "Removed From Favourites",
            font: .systemFont(ofSize: 14.0)
        )
    }
    
    func showData() {

        updateVisibleSections()

        collectionView.reloadData()
    }
    
    func showLoading() {
        self.activityIndicator.startAnimating()
        self.collectionView.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        self.activityIndicator.stopAnimating()
        self.collectionView.isUserInteractionEnabled = true
    }
    
    
    func navigateToTeamDetails(with teamId: String, sport: Sport) {
        let detailsVC = TeamDetailsViewController()
        detailsVC.configure(with: teamId, sport: sport)
        navigationItem.backButtonDisplayMode = .minimal

        navigationController?.pushViewController(detailsVC, animated: true)
    }
    private func updateVisibleSections() {

        visibleSections.removeAll()

        if (presenter?.getUpComingEventsCount() ?? 0) > 0 {
            visibleSections.append(.upcomingEvents)
        }

        if (presenter?.getLatestEventsCount() ?? 0) > 0 {
            visibleSections.append(.latestEvents)
        }

        if (presenter?.getTeamsCount() ?? 0) > 0 {
            visibleSections.append(.teams)
        }
    }
}
