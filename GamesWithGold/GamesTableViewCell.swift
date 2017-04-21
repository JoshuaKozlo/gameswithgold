//
//  GamesTableViewCell.swift
//  GamesWithGold
//
//  Created by joshua kozlowski on 4/6/17.
//  Copyright © 2017 joshua kozlowski. All rights reserved.
//

import UIKit
import SDWebImage

class GamesTableViewCell: UITableViewCell {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    
    func configureCell(game: Game) {
        nameLabel.text = game.name
        
        if game.start != nil && game.end != nil {
            configureRange(start: game.start!, end: game.end!)
        }
        
        if game.img != nil {
            gameImage.sd_setImage(with: URL(string: game.img!))
        }
        
        if game.platform == 1 {
            platformLabel.text = "One"
        } else if game.platform == 2 {
            platformLabel.text = "One & 360"
        } else if game.platform == 3 {
            platformLabel.text = "360"
        }
    }
    
    func configureRange(start: Date, end: Date) {
        let date = Date()
        let calendar = NSCalendar.current
        
        if calendar.isDateInToday(end) {
            self.backgroundColor = UIColor(red: 234 / 255, green: 67 / 255, blue: 53 / 255, alpha: 0.5)
            rangeLabel.text = "Last Day to get for free!"
            
        } else if date >= start && date < end {
            let date1 = calendar.startOfDay(for: date)
            let date2 = calendar.startOfDay(for: end)
            let days = calendar.dateComponents([.day], from: date1, to: date2).day
            self.backgroundColor = UIColor(red: 16 / 255, green: 124 / 255, blue: 15 / 255, alpha: 0.1)
            rangeLabel.text = "Free for \(days! + 1) more days"
            
        } else if  date > end {
            rangeLabel.text = "Title is no longer free."
            
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd"
            rangeLabel.text = "Free starting \(dateFormatter.string(from: start))"
            
        }
    }
}
