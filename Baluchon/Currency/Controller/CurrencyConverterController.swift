//
//  CurrencyConverterController.swift
//  Baluchon
//
//  Created by Dusan Orescanin on 29/03/2022.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    let converter = CurrencyConverter()
    
    // MARK: - @IBOutlet

    @IBOutlet var amountToExchange: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var goButton: UIButton!
    @IBOutlet var amountExchanged: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Do any additional setup after loading the view.

        amountToExchange.delegate = self
        toggleActivityIndicator(shown: false)
        
        amountToExchange.text = "1"
        textFieldDidEndEditing(amountToExchange)
            
        /// This function is called in viewDidLoad to ask the model the currency information of 1 EUR.
        tappedGoButton(UIButton())
    }
    
    // MARK: - @IBAction

    @IBAction func tappedGoButton(_ sender: Any) {
        toggleActivityIndicator(shown: true)
        
        view.endEditing(true)
        
        converter.convert(from: amountToExchange.text ?? "") { (result) in
            self.toggleActivityIndicator(shown: false)
            switch result {
            case let .success(usdValue):
                let value = self.convertDoubleToCurrency(amount: usdValue, locale: Locale(identifier: "en_US"))
                self.amountExchanged.text = value
                
            case let .failure(error):
            self.presentUIAlert(message: error.message)
            }
        }
    }
    @IBAction func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
        amountToExchange.resignFirstResponder()
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        goButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    func convertDoubleToCurrency(amount: Double, locale: Locale) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
}

extension CurrencyViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, let double = Double(text) {
            let value = convertDoubleToCurrency(amount: double, locale: Locale(identifier: "fr_FR"))
            textField.text = value
        }
    }
}
