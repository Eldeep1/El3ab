//
//  LeagueTableViewCell.swift
//  El3ab
//
//  Created by depo on 06/06/2026.
//

import UIKit

class LeagueTableViewCell: UITableViewCell {

    @IBOutlet weak var leagueTitle: UILabel!
    @IBOutlet weak var leagueCountry: UILabel!
    @IBOutlet weak var leagueImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        leagueImageView.layer.cornerRadius = 12
        leagueImageView.clipsToBounds = true
        
        self.selectionStyle = .none
        self.backgroundColor = .cellColor
        self.contentView.backgroundColor = .cellColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //will navigate somehow later, think from the actual table view

        // Configure the view for the selected state
    }
    
}
