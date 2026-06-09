//
//  LeagueDetailsViewController.swift
//  El3ab
//
//  Created by depo on 07/06/2026.
//

import UIKit
import Alamofire
class LeagueDetailsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var selectedLeague: Leagues?
      private var currentSport: Sport = .football
    func configureSelectedLeague(league: Leagues, sport: Sport) {
        self.selectedLeague = league
        self.currentSport = sport
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
        
    
    }
    @objc func favouriteTapped(){
        print("save to core data...")
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
protocol LeagueDetailsViewControllerProtocol: AnyObject {
    
    
    func navigateToTeamDetails(with team: Team)
}

extension LeagueDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return LeagueSections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section==2){
//            presenter.didSelectTeam(at: indexPath.item)
            print("we've clicked here")
            navigateToTeamDetails(with: Team(name: "help", logoImageName: "String", players: [], coaches: []))
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let sectionType = LeagueSections(rawValue: section) else { return 0 }
//        switch sectionType {
//        case .upcomingEvents: return presenter.getUpcomingEventsCount()
//        case .latestEvents: return presenter.getLatestEventsCount()
//        case .teams: return presenter.getTeamsCount()
//        }
        print("intersting actually")
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = LeagueSections(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch sectionType {
        case .upcomingEvents:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpComingEventsViewCell", for: indexPath) as! UpComingEventsViewCell
//            let model = presenter.getUpComingEvent(indexPath.item)
            // cell.configure(with: model)
            return cell
            
        case .latestEvents:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestEventsCollectionViewCell", for: indexPath) as! LatestEventsCollectionViewCell
//            let model = presenter.getLatestEvent(indexPath.item)
            // cell.configure(with: model)
            return cell
            
        case .teams:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamsCollectionViewCell", for: indexPath) as! TeamsCollectionViewCell
//            let model = presenter.getTeams(indexPath.item)
            // cell.configure(with: model)
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
extension LeagueDetailsViewController : LeagueDetailsViewControllerProtocol{
    
    func navigateToTeamDetails(with team: Team) {
        let detailsVC = TeamDetailsViewController()
        
        
//        detailsVC.configure(with: team)
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}
