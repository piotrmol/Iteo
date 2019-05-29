//
//  ViewControllerExtension.swift
//  Iteo
//
//  Created by Piotr Mol on 29/05/2019.
//  Copyright © 2019 Piotr Mol. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorAlert(with title: String, buttonText: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonText, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
