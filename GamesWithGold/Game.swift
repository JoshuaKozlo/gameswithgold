 //
//  Game.swift
//  GamesWithGold
//
//  Created by joshua kozlowski on 4/6/17.
//  Copyright © 2017 joshua kozlowski. All rights reserved.
//

import UIKit

struct Game {
    let name: String?
    let platform: Int?
    let img: String?
    var start: Date?
    var end: Date?
    
    init(object: NSDictionary) {
        self.name = object["name"] as? String
        self.platform = object["platform"] as? Int
        self.img = object["img"] as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if object["start"] != nil && object["end"] != nil {
            self.start = dateFormatter.date(from: object["start"] as! String)
            self.end = dateFormatter.date(from: object["end"] as! String)
        }
        
    }
}
