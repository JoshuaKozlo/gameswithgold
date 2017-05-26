//
//  CommentsCollectionViewController.swift
//  GamesWithGold
//
//  Created by joshua kozlowski on 4/29/17.
//  Copyright © 2017 joshua kozlowski. All rights reserved.
//

import UIKit
import Firebase

class CommentsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var month: Month! {
        didSet {
            navigationItem.title = "\(month.name) Comments"
            
            observeComments()
        }
    }
    
    var comments = [Comment]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(CommentCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
        
        setDisplayName()

    }
    
    func setDisplayName() {
        if ((Auth.auth().currentUser?.displayName) != nil) {
            return
        } else {
            let alert = UIAlertController(title: "Enter Gamertag", message: "Name used to identify you in comment section.", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = "User"
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = textField?.text
                changeRequest?.commitChanges(completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Database.database().reference().child("comments").child(month.id).removeAllObservers()
    }
    
    lazy var inputContainerView: CommentInputContainerView = {
        let commentInputContainerView = CommentInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        commentInputContainerView.commentsLogController = self
        return commentInputContainerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCollectionViewCell
        
        let comment = comments[indexPath.item]
        cell.textView.text = comment.text
        
        setupCell(cell: cell, comment: comment)
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: comment.text!).width + 32
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    private func setupCell(cell: CommentCollectionViewCell, comment: Comment) {
        
        if comment.senderId == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell.bubbleView.backgroundColor = CommentCollectionViewCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.senderNameView.isHidden = true
            
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.bubbleViewRightAnchor?.isActive = true

        } else {
            //incoming gray
            cell.bubbleView.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 240 / 255)
            cell.textView.textColor = UIColor.black
            
            cell.senderNameView.text = comment.senderName
            cell.senderNameView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let text = comments[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }

    func observeComments() {
        let ref = Database.database().reference().child("comments").child(month.id)
        
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let comment = Comment()
            comment.setValuesForKeys(dictionary)
            self.comments.append(comment)
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            
        })
    }
        
    func handleSend() {
        let ref = Database.database().reference().child("comments").child(month.id)
        let childRef = ref.childByAutoId()
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let values = ["text": inputContainerView.inputTextField.text!, "senderName": user.displayName ?? "", "senderId": user.uid]
        childRef.updateChildValues(values)
        self.inputContainerView.inputTextField.text = nil
        self.inputContainerView.sendButton.isEnabled = false
        self.inputContainerView.inputTextField.endEditing(true)
    }
}
