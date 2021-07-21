//
//  APIManager.swift
//  MessagesScreen
//
//  Created by Nikita Entin on 22.07.2021.
//

import Foundation

final class APIManager {
    func fetch<T: Codable>(completion: @escaping (T) -> ()) {
        let path = "https://s3-eu-west-1.amazonaws.com/builds.getmobileup.com/storage/MobileUp-Test/api.json"
        guard let url = URL(string: path) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error as? URLError, error.code == .notConnectedToInternet {
                print("No internet connection")
            }
            if let response = response as? HTTPURLResponse, response.statusCode == 503 {
                print("No connection to server. Please, try again later")
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
