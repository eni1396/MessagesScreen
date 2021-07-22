//
//  APIManager.swift
//  MessagesScreen
//
//  Created by Nikita Entin on 22.07.2021.
//

import Foundation

final class APIManager {
    private let serviceUnavailable = 503
    
    ///Загрузка данных из сети
    func fetch<T: Codable>(completion: @escaping (T) -> (), errorHandler: @escaping (HTTPURLResponse?) -> ()) {
        let path = "https://s3-eu-west-1.amazonaws.com/builds.getmobileup.com/storage/MobileUp-Test/api.json"
        guard let url = URL(string: path) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == self.serviceUnavailable {
                errorHandler(response)
            }
            guard let data = data else { return }
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(object)
            } catch let error as NSError {
                print(error.userInfo)
            }
        }.resume()
    }
}
