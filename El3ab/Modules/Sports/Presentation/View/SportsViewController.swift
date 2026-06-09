//
//  SportsViewController.swift
//  El3ab
//
//  Created by Osama Khaled on 05/06/2026.
//

import UIKit

class SportsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    private let sports = ["Football", "Basketball", "Tennis", "Cricket"]
    
    private let sportsCollectionView: UICollectionView = {
         let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .vertical
         layout.minimumLineSpacing = 20
         layout.minimumInteritemSpacing = 20
         layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
         collectionView.backgroundColor = .bgColor
         collectionView.translatesAutoresizingMaskIntoConstraints = false
         return collectionView
     }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "El3ab"
        view.backgroundColor = .bgColor
        navigationItem.backButtonDisplayMode = .minimal
        setupCollectionView()
        setupConstraints()
    }
    
    private func setupCollectionView() {
         sportsCollectionView.delegate = self
         sportsCollectionView.dataSource = self
         sportsCollectionView.register(SportsCollectionViewCell.self,
                                     forCellWithReuseIdentifier: SportsCollectionViewCell.identifier)
         view.addSubview(sportsCollectionView)
     }
     
     private func setupConstraints() {
         NSLayoutConstraint.activate([
             sportsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             sportsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             sportsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             sportsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         ])
     }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sports.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SportsCollectionViewCell.identifier,
            for: indexPath
        ) as? SportsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let sport = sports[indexPath.item]
        cell.configure(with: sport)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 20
        let insets: CGFloat = 40
        let totalSpacing = spacing + insets
        let width = (collectionView.bounds.width - totalSpacing) / 2
        let height = width * 1.4 // Made height bigger
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSport = sports[indexPath.item]
        print("Selected: \(selectedSport)")
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let sportEnum: Sport
        switch selectedSport.lowercased() {
        case "football":
            sportEnum = .football
        case "basketball":
            sportEnum = .basketball
        case "tennis":
            sportEnum = .tennis
        case "cricket":
            sportEnum = .cricket
        default:
            sportEnum = .football
        }
        let leaguesVC = LeaguesViewController()
        leaguesVC.selectedSport = sportEnum
        leaguesVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(leaguesVC, animated: true)
    }
}
