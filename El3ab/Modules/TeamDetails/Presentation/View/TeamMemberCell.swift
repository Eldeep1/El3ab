//
//  TeamMemberCell.swift
//  El3ab
//
//  Created by Osama Khaled on 06/06/2026.
//

import UIKit

class TeamMemberCell: UICollectionViewCell {
    
    static let identifier = "TeamMemberCell"
        
        private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 50
            imageView.clipsToBounds = true
            imageView.backgroundColor = .systemGray5
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        private let nameLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16, weight: .semibold)
            label.textColor = .white
            label.textAlignment = .center
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let subtitleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12, weight: .regular)
            label.textColor = .systemGray2
            label.textAlignment = .center
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
            contentView.addSubview(imageView)
            contentView.addSubview(nameLabel)
            contentView.addSubview(subtitleLabel)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 100),
                imageView.heightAnchor.constraint(equalToConstant: 100),
                
                nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
                nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
                nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
                
                subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
                subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
                subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
                subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
            ])
        }
        
        func configure(with player: Player) {
            nameLabel.text = player.name
            imageView.image = UIImage(named: player.imageName)
            
            if let position = player.position, let number = player.number {
                subtitleLabel.text = "\(position) • #\(number)"
            } else if let position = player.position {
                subtitleLabel.text = position
            } else if let number = player.number {
                subtitleLabel.text = "#\(number)"
            } else {
                subtitleLabel.text = "Player"
            }
        }
        
        func configure(with coach: Coach) {
            nameLabel.text = coach.name
            imageView.image = UIImage(named: coach.imageName)
            subtitleLabel.text = coach.role
        }

}
