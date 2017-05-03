//
//  CommentCollectionViewCell.swift
//  GamesWithGold
//
//  Created by joshua kozlowski on 4/29/17.
//  Copyright © 2017 joshua kozlowski. All rights reserved.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Sameple text"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        return tv
    }()
    
    static let blueColor = UIColor(red: 0, green: 137 / 255, blue: 259 / 255, alpha: 1)
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let senderNameView: UILabel = {
        let tv = UILabel()
        tv.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.lightGray
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(senderNameView)
        
        senderNameView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        senderNameView.bottomAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        senderNameView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        senderNameView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // constraints
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
    
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // constraints
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
