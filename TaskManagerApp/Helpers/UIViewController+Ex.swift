//
//  UIViewController+Ex.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/4/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    func handleError(error:Error) {
        let alertViewController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func addHideKeyboardAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func endEditing() {
       self.view.endEditing(true)
    }
}
