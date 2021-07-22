//
//  Reachability.swift
//  MessagesScreen
//
//  Created by Nikita Entin on 22.07.2021.
//

import Foundation
import Network

class NetworkReachability {
    
    var pathMonitor: NWPathMonitor!
    var path: NWPath?
    lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in
        self.path = path
        if path.status == .satisfied {
            print("Connected")
        } else if path.status == .unsatisfied {
            print("unsatisfied")
        } else if path.status == .requiresConnection {
            print("requiresConnection")
        }
    }
    
    let backgroudQueue = DispatchQueue.global(qos: .default)
    
    init() {
        pathMonitor = NWPathMonitor()
        pathMonitor.pathUpdateHandler = self.pathUpdateHandler
        pathMonitor.start(queue: backgroudQueue)
    }
    ///Проверка наличия сети на устройстве
    func isNetworkAvailable() -> Bool {
        if let path = self.path {
            if path.status == .satisfied {
                return true
            }
        }
        return false
    }
}
