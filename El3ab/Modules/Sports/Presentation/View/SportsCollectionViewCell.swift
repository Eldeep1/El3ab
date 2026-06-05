//
//  SportsCollectionViewCell.swift
//  El3ab
//
//  Created by Osama Khaled on 05/06/2026.
//

import UIKit

class SportsCollectionViewCell: UICollectionViewCell {
    static let identifier = "SportsCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sportImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill  // Changed to fill the container
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4) // Dark overlay for better text visibility
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sportLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white  // White text for contrast against image
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(sportImageView)
        containerView.addSubview(overlayView)
        containerView.addSubview(sportLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Image covers entire container
            sportImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            sportImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            sportImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sportImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Overlay covers entire container
            overlayView.topAnchor.constraint(equalTo: containerView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Label centered in the container
            sportLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            sportLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            sportLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 16),
            sportLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with sport: String) {
        sportLabel.text = sport
        sportImageView.image = getSportIcon(for: sport)
    }
    
    private func getSportIcon(for sport: String) -> UIImage? {
        switch sport.lowercased() {
        case "football":
            return UIImage(named: "football_icon")
        case "basketball":
            return UIImage(named: "basketball_icon")
        case "tennis":
            return UIImage(named: "tennis_icon")
        case "cricket":
            return UIImage(named: "cricket_icon")
        default:
            return UIImage(systemName: "sportscourt")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sportLabel.text = nil
        sportImageView.image = nil
    }
}
