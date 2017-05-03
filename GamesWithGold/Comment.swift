//
//  Comment.swift
//  GamesWithGold
//
//  Created by joshua kozlowski on 4/29/17.
//  Copyright © 2017 joshua kozlowski. All rights reserved.
//

import UIKit
import Firebase

class Comment: NSObject {
    var senderId: String?
    var senderName: String?
    var text: String?
    
    func isSender() -> Bool? {
        if senderId == FIRAuth.auth()?.currentUser?.uid {
            return true
        } else {
            return false
        }
    }
}
