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
    
    let myGreen = UIColor(red: 108.0/255.0, green: 150.0/255.0, blue: 58.0/255.0, alpha: 1.0)
    
    var isSavingsZero: Bool = false;
    var price = 20.0;
    var discount = 0.1;
    var tax = 0.08;
    var quant = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTotal()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    @IBAction func discountEdited(_ sender: UITextField) {
        
        let d = Double(sender.text!) ?? 0.0
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
        }
    }
    
    @IBAction func taxEdited(_ sender: UITextField) {
        
        let t = Double(sender.text!) ?? 0.0
        tax = t / 100
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
            sender.text = String(format: "%2.1f", tax * 100)
        }
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
    }

    
    func refreshTotal() {
        
        // FIXME: Include Commas for longer numbers
        let total = ( (price * (1 - discount) *  Double(quant) ) * (1 + tax) )
        totalLabel.text = String(format: "$%2.2f", total)
        
        let noDiscount = price * Double(quant) * (1 + tax);
        savingsLabel.text = String(format: "$%2.2f",  noDiscount - total)
        
        if noDiscount <= total {
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

