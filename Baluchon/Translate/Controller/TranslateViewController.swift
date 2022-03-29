//
//  TranslateViewController.swift
//  Baluchon
//
//  Created by Dusan Orescanin on 29/03/2022.
//

import UIKit

class TranslateViewController: UIViewController {
    
    // MARK: - @IBOutlet

    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var outputTextView: UITextView!
    @IBOutlet var goButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let translation = Translation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - @IBAction

    @IBAction func tappedGoButton(_ sender: Any) {
        view.endEditing(true)
        
        translation.request(from: inputTextView.text) { (result) in
            switch result {
            case let .success(translatedText):
                self.outputTextView.text = translatedText
            case let .failure(error):
                self.presentUIAlert(message: error.message)
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        inputTextView.resignFirstResponder()
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        goButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}
