//
//  ViewController.swift
//  MessagesScreen
//
//  Created by Nikita Entin on 22.07.2021.
//

import UIKit

class MessagesViewController: PresenterDelegate {

    @IBOutlet weak var table: UITableView!
    
    private let presenter = MessagesPresenter()
    private var messages = [Messages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UINib(nibName: "CurrentMessageCell", bundle: nil), forCellReuseIdentifier: "currentChat")
        presenter.setViewDelegate(delegate: self)
        presenter.fetchMessages()
    }

    func getMessages(messages: [Messages]) {
        self.messages = messages
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "currentChat", for: indexPath) as! CurrentMessageCell
        presenter.getImages(messages: messages, at: indexPath) { image in
            DispatchQueue.main.async {
                cell.userImageView.image = image
                cell.userImageView.tintColor = .gray
            }
        }
        cell.userNameLabel.text = messages[indexPath.row].user.nickname
        cell.messageLabel.text = messages[indexPath.row].message.text
        
        let date = messages[indexPath.row].message.receivingDate
        cell.dateLabel.text = "\(presenter.getDate(from: date))"
        print("\(presenter.getDate(from: date))")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
