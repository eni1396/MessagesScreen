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
    
    func getImages(messages: [Messages], at indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
        let path = messages[indexPath.row].user.avatarURL
        if path.isEmpty {
            completion(UIImage(systemName: "person.crop.circle"))
        }
        guard let url = URL(string: path),
              let data = try? Data(contentsOf: url) else { return }
        let image = UIImage(data: data)
        completion(image)
    }
    
    func getDate(from string: String) -> String {
        let days = [1: "Monday", 2: "Tuesday", 3:"Wednesday", 4: "Thursday", 5:"Friday", 6: "Saturday", 7: "Sunday"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let date = dateFormatter.date(from: string) else { return "" }
        
        func getDayOfWeek(_ today:String = "2020-10-14") -> Int {
            let formatter  = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            guard let todayDate = formatter.date(from: today) else { return -1 }
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: todayDate) -  myCalendar.component(.weekday, from: date)
            return weekDay
        }
        let secDateF = DateFormatter()
        secDateF.dateFormat = "HH:mm"
        
        if getDayOfWeek() == 1 {
            return "Yesterday"
        } else if getDayOfWeek() > 1 {
            return days[getDayOfWeek()]!
        } else {
            return secDateF.string(from: date)
        }
    }
}
