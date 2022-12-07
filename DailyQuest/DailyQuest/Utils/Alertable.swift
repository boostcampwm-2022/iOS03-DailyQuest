//
//  Alertable.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/07.
//

import UIKit

protocol Alertable {}

extension Alertable where Self: UIViewController {
    func showAlert(title: String,
                   message: String,
                   preferredStyle: UIAlertController.Style = .alert,
                           completion: (() -> Void)? = nil)
    {
        let title = title
        let message = message
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: completion)
    }
}
