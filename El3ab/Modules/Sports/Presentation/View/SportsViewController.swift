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
         layout.minimumLineSpacing = 16
         layout.minimumInteritemSpacing = 16
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
            let spacing: CGFloat = 16
            let insets: CGFloat = 40 // 20 on each side
            let totalSpacing = spacing + insets
            let width = (collectionView.bounds.width - totalSpacing) / 2
            let height = width * 1.2 // Aspect ratio for sports cards
            
            return CGSize(width: width, height: height)
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedSport = sports[indexPath.item]
            print("Selected: \(selectedSport)")
            
            // Add haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            // You can add navigation to a detail view controller here
            // let detailVC = SportDetailViewController(sport: selectedSport)
            // navigationController?.pushViewController(detailVC, animated: true)
        }

}
