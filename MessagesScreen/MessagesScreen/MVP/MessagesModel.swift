//
//  MessagesInteractor.swift
//  MessagesScreen
//
//  Created by Nikita Entin on 22.07.2021.
//

import Foundation


struct MessagesModel {
    
    // MARK: - WelcomeElement
    struct WelcomeElement: Codable {
        let user: User
        let message: Message
    }

    // MARK: - Message
    struct Message: Codable {
        let text: String
        let receivingDate: Date

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
}
