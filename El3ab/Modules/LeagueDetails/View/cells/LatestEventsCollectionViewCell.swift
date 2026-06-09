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
    
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var matchTeamsLabel: UILabel!
    @IBOutlet weak var matchTimeLabel: UILabel!
    @IBOutlet weak var matchScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = .cellColor
    }

}
