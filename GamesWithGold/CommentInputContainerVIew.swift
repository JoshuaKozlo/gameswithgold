//
//  CommentInputContainerVIew.swift
//  GamesWithGold
//
//  Created by joshua kozlowski on 5/1/17.
//  Copyright © 2017 joshua kozlowski. All rights reserved.
//

import UIKit

class CommentInputContainerView: UIView, UITextFieldDelegate {
    
    var commentsLogController: CommentsCollectionViewController? {
        didSet {
            sendButton.addTarget(commentsLogController, action: #selector(CommentsCollectionViewController.handleSend), for: .touchUpInside)
        }
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter comment..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.send
        return textField
    }()
    
    let sendButton = UIButton(type: .system)
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentsLogController?.handleSend()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 255 // Bool
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text
        if text != nil && text?.isEmpty == false {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sendButton)
        // x, y, h, w
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        sendButton.isEnabled = false
        
        addSubview(self.inputTextField)
        // x, y, h, w
        self.inputTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        self.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.inputTextField.enablesReturnKeyAutomatically = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLineView)
        // x, y, h , w
        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
