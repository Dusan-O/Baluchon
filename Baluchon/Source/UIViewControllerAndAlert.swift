//
//  UIViewControllerAndAlert.swift
//  Baluchon
//
//  Created by Dusan Orescanin on 29/03/2022.
//

import UIKit

extension UIViewController {
    
    func presentUIAlert(message: String) {
        
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}

