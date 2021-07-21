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
        let cell = table.dequeueReusableCell(withIdentifier: "currentChat", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row].user.nickname
        return cell
    }
    
    
}
