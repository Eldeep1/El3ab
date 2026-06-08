//
//  UpComingEventsViewCell.swift
//  El3ab
//
//  Created by depo on 07/06/2026.
//

import UIKit

class UpComingEventsViewCell: UICollectionViewCell {
        
       
        @IBOutlet weak var teamLogoImageView: UIImageView!
        @IBOutlet weak var enemyLogoImageView: UIImageView!
        
        
        @IBOutlet weak var vsLabel: UILabel!
        @IBOutlet weak var matchTeamsLabel: UILabel!
        @IBOutlet weak var matchTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = .cellColor
    }

}
