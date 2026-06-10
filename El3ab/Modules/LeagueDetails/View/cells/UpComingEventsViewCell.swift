//
//  UpComingEventsViewCell.swift
//  El3ab
//
//  Created by depo on 07/06/2026.
//

import UIKit
import Kingfisher

class UpComingEventsViewCell: UICollectionViewCell {
        
       
        @IBOutlet weak var teamLogoImageView: UIImageView!
        @IBOutlet weak var enemyLogoImageView: UIImageView!
        
        
        @IBOutlet weak var vsLabel: UILabel!
        @IBOutlet weak var matchTeamsLabel: UILabel!
        @IBOutlet weak var matchTimeLabel: UILabel!
        override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .cellColor
    }
    func configure(event: Event) {
            let home = event.homeTeamName ?? "NAN"
            let away = event.enemyTeamName ?? "NAN"
            matchTeamsLabel.text = "\(home) vs \(away)"
            
            let date = event.eventDate ?? ""
            let time = event.eventTime ?? ""
            matchTimeLabel.text = "\(date) | \(time)".trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let homeLogoUrl = event.homeTeamLogo, let url = URL(string: homeLogoUrl) {
                teamLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_logo"))
            } else {
                teamLogoImageView.image = UIImage(systemName: "calendar.badge.exclamationmark")
            }
            
            if let awayLogoUrl = event.awayTeamLogo, let url = URL(string: awayLogoUrl) {
                enemyLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_logo"))
            } else {
                enemyLogoImageView.image = UIImage(systemName: "calendar.badge.exclamationmark")
            }
        }

}
