//
//  MessagesInteractor.swift
//  MessagesScreen
//
//  Created by Nikita Entin on 22.07.2021.
//

import Foundation


// MARK: - Модель для парсинга
struct Messages: Codable {
    let user: User
    let message: CurrentMessage
}

// MARK: - Message
struct CurrentMessage: Codable {
    let text: String
    let receivingDate: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case receivingDate = "receiving_date"
    }
}

// MARK: - User
struct User: Codable {
    let nickname: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case avatarURL = "avatar_url"
    }
}
