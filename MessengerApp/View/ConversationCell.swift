//
//  ConversationCell.swift
//  MessengerApp
//
//  Created by Admin on 04/09/22.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    // MARK: - Properties
    
    var conversation: Conversation? {
        didSet { configure()}
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let usernameLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 14)
        return lable
    }()
    
    private let messageTextLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    private let timestamp: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textColor = .darkGray
        lable.text = "3h"
        return lable
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(height: 52, width: 52)
        profileImageView.layer.cornerRadius = 52 / 2
        
        let stack = UIStackView(arrangedSubviews: [usernameLable, messageTextLable])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
        
        addSubview(timestamp)
        timestamp.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        
        guard let conversation = conversation else { return}
        let viewModel = ConversationViewModel(conversation: conversation)
        
        usernameLable.text = conversation.user.username
        messageTextLable.text = conversation.message.text
        
        timestamp.text = viewModel.timestamp
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
}
