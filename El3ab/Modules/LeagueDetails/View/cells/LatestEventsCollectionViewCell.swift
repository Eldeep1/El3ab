//
//  LatestEventsCollectionViewCell.swift
//  El3ab
//
//  Created by depo on 07/06/2026.
//

import UIKit

class LatestEventsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var enemyLogoImageView: UIImageView!
    
    // Labels
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var matchTeamsLabel: UILabel!
    @IBOutlet weak var matchTimeLabel: UILabel!
    @IBOutlet weak var matchScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.backgroundColor = .cellColor
    }

}
