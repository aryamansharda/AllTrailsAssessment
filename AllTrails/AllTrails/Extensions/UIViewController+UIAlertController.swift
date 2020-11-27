//
//  UIViewController+UIAlertController.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/26/20.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(alertText: String, alertMessage: String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.alertConfirmation, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
