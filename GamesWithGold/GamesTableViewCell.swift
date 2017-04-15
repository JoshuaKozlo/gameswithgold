//
//  GamesTableViewCell.swift
//  GamesWithGold
//
//  Created by joshua kozlowski on 4/6/17.
//  Copyright © 2017 joshua kozlowski. All rights reserved.
//

import UIKit

class GamesTableViewCell: UITableViewCell {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    
    func configureCell(game: Game) {
        nameLabel.text = game.name
        platformLabel.text = game.platform
        rangeLabel.text = game.range
        if (game.img as String?) != nil {
            gameImage.downloadedFrom(link: game.img!)
        }
    }

}
