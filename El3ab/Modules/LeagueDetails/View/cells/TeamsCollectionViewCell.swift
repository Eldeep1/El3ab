//
//  TeamsCollectionViewCell.swift
//  El3ab
//
//  Created by depo on 07/06/2026.
//

import UIKit

class TeamsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var teamLogoImageView: UIImageView!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(team: Team) {
        let label = team.name
       
        if let url = URL(string: team.logoImageName) {
            teamLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_logo"))
        } else {
            teamLogoImageView.image = UIImage(named: "placeholder_logo")
        }
    }

}
