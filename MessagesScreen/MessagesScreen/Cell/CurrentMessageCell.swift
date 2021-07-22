//
//  CurrentMessageCell.swift
//  MessagesScreen
//
//  Created by Nikita Entin on 22.07.2021.
//

import UIKit

class CurrentMessageCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
