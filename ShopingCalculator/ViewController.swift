//
//  ViewController.swift
//  ShopingCalculator
//
//  Created by Corban Swain on 1/27/17.
//  Copyright © 2017 CorbanSwain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var savingsLabel: UILabel!
    
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var discountField: UITextField!
    @IBOutlet weak var taxField: UITextField!
    
    
    var currentTextField: UITextField?
    var textFields = [UITextField]()
//    var keyboardAccessory = [KeyboardAccessoryView]()
    
    let myGreen = UIColor(red: 108.0/255.0, green: 150.0/255.0, blue: 58.0/255.0, alpha: 1.0)
    
    var isSavingsZero: Bool = false;
    var price = 20.0;
    var discount = 0.1;
    var tax = 0.08;
    var quant = 1;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow a tap on screen to dismiss the keyboard
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.respondToTap)))
        refreshTotal()
        
//        textFields = [priceField, quantityField, discountField, taxField]
        
        // Adding a "Done" button to each text field keyboard
//        for (_, field) in textFields.enumerated() {
//            field.inputAccessoryView = Bundle.main.loadNibNamed("KeyboardAccessoryView", owner: self, options: nil)?.first as! UIView?
//            keyboardAccessory.append(field.inputAccessoryView! as! KeyboardAccessoryView)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func respondToTap() {
        if let textField = currentTextField {
            dismissKeyboard(textField)
            currentTextField = nil
        }
    }
    
    @IBAction func priceFieldTouched(_ sender: UITextField) {
        if currentTextField != sender { currentTextField = sender }
    }
    
    @IBAction func priceEdited(_ sender: UITextField) {
        price = Double(sender.text!) ?? 0.0
        if price < 0 {
            price = 0
            sender.text = "0.00"
        }
        refreshTotal()
    }
    
    @IBAction func priceClickedAway(_ sender: UITextField) {
        sender.text = String(format: "%2.2f",price)
        priceEdited(sender)
    }
    
    
    @IBAction func quantityFieldTouched(_ sender: UITextField) {
        if currentTextField != sender { currentTextField = sender }
    }
    
    @IBAction func quantityChanged(_ sender: UITextField) {
        quant = Int((Double(sender.text!) ?? 0.0))
        if quant < 0 {
            quant = 0;
        }
        refreshTotal()
    }
    
    @IBAction func quantityClickedAway(_ sender: UITextField) {
        sender.text = String(quant)
        quantityChanged(sender)
    }
    
    
    @IBAction func discountFieldTouched(_ sender: UITextField) {
        if currentTextField != sender { currentTextField = sender }
    }
    
    @IBAction func discountEdited(_ sender: UITextField) {
        guard let text = sender.text, let d = Double(text) else {
            discount = 0
            refreshTotal()
            return
        }
        discount = d / 100
        if discount < 0 {
            discount = 0
            sender.text = "0"
        }
        else if discount > 1 {
            discount = 1
            sender.text = "100";
        }
        refreshTotal()
    }
    
    @IBAction func discountClickedAway(_ sender: UITextField) {
        if let isDecimal = (sender.text?.contains(".")), isDecimal {
            sender.text = String(format: "%2.1f", discount * 100)
        } else {
            sender.text = String(format: "%2.0f", discount * 100)
        }
        discountEdited(sender)
    }
    
    @IBAction func taxFieldTouched(_ sender: UITextField) {
        if currentTextField != sender { currentTextField = sender }
    }
    
    @IBAction func taxEdited(_ sender: UITextField) {
        guard let text = sender.text, let t = Double(text) else {
            tax = 0
            refreshTotal()
            return
        }
        tax = t / 100.0
        if tax < 0 {
            tax = 0
            sender.text = "0"
        }
        else if tax > 1 {
            tax = 1
            sender.text = "100";
        }
        refreshTotal()
    }
    
    
    @IBAction func taxClickedAway(_ sender: UITextField) {
        if let isDecimal = sender.text?.contains("."), isDecimal {
            sender.text = String(format: "%2.1f", tax * 100.0)
        } else {
            sender.text = String(format: "%2.0f", tax * 100.0)
        }
        taxEdited(sender)
    }
    
    func refreshTotal() {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currencyAccounting
        
        let total = ( (price * (1 - discount) *  Double(quant) ) * (1 + tax) )
        totalLabel.text = currencyFormatter.string(from: total)
        let savings = price * Double(quant) * (1 + tax) - total;
        savingsLabel.text = currencyFormatter.string(from: savings)
        
        if savings <= 0 {
            if !isSavingsZero {
                savingsLabel.textColor = UIColor.gray
                isSavingsZero = true
            }
        } else if isSavingsZero {
            
            savingsLabel.textColor = myGreen
            isSavingsZero = false
        }
    }

}

extension NumberFormatter {
    func string(from number: Double) -> String {
        return self.string(from: NSNumber(value: number)) ?? ""
    }
}

extension UIViewController {
    func dismissKeyboard(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}


