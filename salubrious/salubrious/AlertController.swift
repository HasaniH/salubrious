//
//  AlertController.swift
//  salubrious
//
//  Created by Hasani Hendrix on 3/15/18.
//  Copyright © 2018 Hasani Hendrix. All rights reserved.
//

import UIKit

class AlertController {
    static func showAlert(_ inViewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        inViewController.present(alert, animated: true, completion: nil)
    }
}
