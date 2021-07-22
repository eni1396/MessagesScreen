//
//  ViewController + Extension.swift
//  MessagesScreen
//
//  Created by Nikita Entin on 22.07.2021.
//

import UIKit

extension UIViewController {
    
    ///Вызов алерта
    public func showAlert(title: String?) {
        let vc = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default, handler: nil)
        vc.addAction(action)
        present(vc, animated: true, completion: nil)
    }
}
