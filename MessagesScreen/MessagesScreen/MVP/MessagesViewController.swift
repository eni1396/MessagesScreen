//
//  ViewController.swift
//  MessagesScreen
//
//  Created by Nikita Entin on 22.07.2021.
//

import UIKit

class MessagesViewController: PresenterDelegate {
    
    @IBOutlet weak var table: UITableView!
    private let cellID = Constants.cellID
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        return indicator
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshView(_:)), for: .valueChanged)
        return rc
    }()
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = .systemFont(ofSize: 15)
        label.text = "Nothing found"
        label.textColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let presenter = MessagesPresenter()
    private var messages = [Messages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.addSubview(indicator)
        table.addSubview(refreshControl)
        table.refreshControl = refreshControl
        table.register(UINib(nibName: "CurrentMessageCell", bundle: nil), forCellReuseIdentifier: cellID)
        presenter.setViewDelegate(delegate: self)
        table.separatorStyle = .none
        checkForConnection()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.messages.isEmpty {
                self.showBlankView()
            }
        }
    }
    //MARK:- Проверка на подключение к сети
    private func checkForConnection() {
        indicator.startAnimating()
        
        if presenter.reachability.isNetworkAvailable() {
                self.presenter.fetchMessages()
              
        } else {
            showBlankView()
            showAlert(title: Constants.noNetworkError)
        }
    }
    //MARK:- обновить таблицу
    @objc private func refreshView(_ sender: UIRefreshControl) {
        checkForConnection()
        sender.endRefreshing()
    }
    //MARK:- Если сети нет, показывать заглушку
    private func showBlankView() {
        table.addSubview(noDataLabel)
        messages = []
        table.reloadData()
        table.separatorStyle = .none
        noDataLabel.isHidden = false
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
        ])
    }
    //MARK:- Presenter delegate methods
    func getMessages(messages: [Messages]) {
        self.messages = messages
        
        DispatchQueue.main.async {
            self.noDataLabel.isHidden = true
            self.table.separatorStyle = .singleLine
            self.refreshControl.endRefreshing()
            self.indicator.stopAnimating()
            self.table.reloadData()
        }
    }
    
    func showErrorAlert(title: String) {
        DispatchQueue.main.async {
            self.showAlert(title: title)
            self.refreshControl.endRefreshing()
        }
    }
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? CurrentMessageCell else { return UITableViewCell() }
        DispatchQueue.global().async {
            self.presenter.getImages(messages: self.messages, at: indexPath) { image in
                DispatchQueue.main.async {
                    cell.userImageView.image = image
                    cell.userImageView.tintColor = .gray
                }
            }
        }
        cell.userNameLabel.text = messages[indexPath.row].user.nickname
        cell.messageLabel.text = messages[indexPath.row].message.text
        
        let date = messages[indexPath.row].message.receivingDate
        cell.dateLabel.text = "\(presenter.getDate(from: date))"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        95
    }
}
