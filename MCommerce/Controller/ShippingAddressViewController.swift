//
//  ShippingAddressViewController.swift
//  MCommerce
//
//  Created by Hein Zaw on 11/18/17.
//  Copyright © 2017 Hein Zaw. All rights reserved.
//

import UIKit
import RealmSwift
import PKHUD

class ShippingAddressViewController: UIViewController {
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var address: UITextField!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func actionOrder(_ sender: Any) {
        
        let savedCart = self.realm.objects(Cart.self).first
        
        let email = UserDefaults.standard.value(forKey: "email") as! String
        
     
        if validated() {
            HUD.show(.progress)
            MCApi.sharedInstance().createAddress(name: name.text!, email: email, country: country.text!, city: city.text!, address1: address.text!, postalCode: postalCode.text!) {
                
            
                success, errorMessage, addressID in
                if success {
                    
                    MCApi.sharedInstance().createOrder(cardId: (savedCart?.id)!, shippingAddressId: addressID!, billingAddressId: addressID!){
                        success , errorMessage in
                        
                        
                        if success {
                            HUD.hide()
                            self.showAlert(title: "", message: "Order Success")
                            
                            let cart = self.realm.objects(Cart.self)
                            try! self.realm.write {
                                self.realm.delete(cart)
                            }
                            MCApi.sharedInstance().createEmptyCart()
                        }
                        
                    }
                }
                    
                
            }
        }
        
      
    }
    
    
    func showAlert(title: String,message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }

    
    
    
    func validated() -> Bool {
        var valid: Bool = true
        if name.text!.isEmpty {
            name.attributedPlaceholder = NSAttributedString(string: "Please enter Your Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
            valid = false
        }
        if country.text!.isEmpty {
            country.attributedPlaceholder = NSAttributedString(string: "Please enter Your Country", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
            valid = false
        }
        if state.text!.isEmpty {
            state.attributedPlaceholder = NSAttributedString(string: "Please enter Your State", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
            valid = false
        }
        if city.text!.isEmpty{
            city.attributedPlaceholder = NSAttributedString(string: "Please enter Your City", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
            valid = false
        }
        if postalCode.text!.isEmpty {
            postalCode.attributedPlaceholder = NSAttributedString(string: "Please enter Your Postal Code", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
            valid = false
        }
        if address.text!.isEmpty {
            address.attributedPlaceholder = NSAttributedString(string: "Please enter Your Address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
            valid = false
        }
        return valid
    }
    

    
}
