//
//  MessagesPresenter.swift
//  MessagesScreen
//
//  Created by Nikita Entin on 22.07.2021.
//

import UIKit

protocol MessagesPresenterDelegate {
    func getMessages(messages: [Messages])
    func showErrorAlert(title: String)
}

typealias PresenterDelegate = MessagesPresenterDelegate & UIViewController

final class MessagesPresenter {
    
    private let apiManager = APIManager()
    let reachability = NetworkReachability()
    private weak var delegate: PresenterDelegate?
    
    func setViewDelegate(delegate: PresenterDelegate) {
        self.delegate = delegate
    }
    
    ///Получение сообщений из сети
    func fetchMessages() {
        apiManager.fetch { [weak self] (messages: [Messages]) in
            self?.delegate?.getMessages(messages: messages)
        } errorHandler: { [weak self] (response) in
            self?.delegate?.showErrorAlert(title: Constants.serverError)
        }
    }
    
    ///Получение изображения пользователя
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
    
    ///Конвертация даты
    func getDate(from string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.ISODateFormat
        
        guard let date = dateFormatter.date(from: string) else { return "" }
        
        // Поиск дня недели относительно заданной даты (первого сообщения)
        func getDayOfWeek(_ today:String = "2020-10-14") -> Int {
            let formatter  = DateFormatter()
            formatter.dateFormat = Constants.yearToDateFormat
            guard let todayDate = formatter.date(from: today) else { return -1 }
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = (myCalendar.component(.weekday, from: todayDate) - myCalendar.component(.weekday, from: date)) % 7
            return weekDay
        }
        let hoursToMinutesDF = DateFormatter()
        hoursToMinutesDF.dateFormat = Constants.hoursToMinutesFormat
        
        if getDayOfWeek() == 1 {
            return "Yesterday"
        } else if getDayOfWeek() > 1 || getDayOfWeek() < 0 {
            return Constants.daysOfTheWeek[abs(getDayOfWeek())] ?? ""
        } else {
            return hoursToMinutesDF.string(from: date)
        }
    }
}
