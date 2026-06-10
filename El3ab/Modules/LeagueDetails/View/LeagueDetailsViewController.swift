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
    func existsInVafourite()
    func showData()
    func showLoading()
    func hideLoading()
}
class LeagueDetailsViewController: UIViewController {
    
    var presenter:LeagueDetailsPresenterProtocol?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    }
    @objc func favouriteTapped(){
        presenter?.addToFavourite()
    }
    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionType = LeagueSections(rawValue: sectionIndex) else { return nil }
            
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
        
        // Fixed width/height for the horizontal card
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(180), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 24, trailing: 16)
        section.orthogonalScrollingBehavior = .continuous // Enforces horizontal scrolling
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LeagueDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return LeagueSections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section==2){
            presenter?.didSelectTeam(at: indexPath.item)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = LeagueSections(rawValue: section) else { return 0 }
        switch sectionType {
        case .upcomingEvents: return presenter?.getUpComingEventsCount() ?? 0
        case .latestEvents: return presenter?.getLatestEventsCount() ?? 0
        case .teams: return presenter?.getTeamsCount() ?? 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = LeagueSections(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
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

        switch LeagueSections(rawValue: indexPath.section) {
        case .upcomingEvents:
            header.titleLabel.text = "Upcoming Events"

        case .latestEvents:
            header.titleLabel.text = "Latest Events"

        case .teams:
            header.titleLabel.text = "Teams"

        case .none:
            header.titleLabel.text = ""
        }

        return header
    }
}
extension LeagueDetailsViewController: LeagueDetailsViewControllerProtocol {
    func addToFavourite() {
        let favouriteButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill") , style: UIBarButtonItem.Style.plain, target: self, action: #selector (favouriteTapped))
        navigationItem.rightBarButtonItem = favouriteButton
    }
    
    func existsInVafourite() {
        self.showToast(message: "Already In Favourites", font: .systemFont(ofSize: 14.0))
    }
    
    func showData() {
        self.collectionView.reloadData()
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
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
