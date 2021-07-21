//
//  MessagesPresenter.swift
//  MessagesScreen
//
//  Created by Nikita Entin on 22.07.2021.
//

import UIKit

protocol MessagesPresenterDelegate {
    func getMessages(messages: [Messages])
}

typealias PresenterDelegate = MessagesPresenterDelegate & UIViewController

final class MessagesPresenter {
    
    private let apiManager = APIManager()
    
    private weak var delegate: PresenterDelegate?
    
    func setViewDelegate(delegate: PresenterDelegate) {
        self.delegate = delegate
    }
    
    func fetchMessages() {
        apiManager.fetch { [weak self] (messages: [Messages]) in
            self?.delegate?.getMessages(messages: messages)
        }
    }
}
