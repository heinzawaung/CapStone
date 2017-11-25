//
//  ProfileViewController.swift
//  MCommerce
//
//  Created by Hein Zaw on 9/27/17.
//  Copyright © 2017 Hein Zaw. All rights reserved.
//


import UIKit
import RealmSwift
import PKHUD

class ProfileViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
    
        
        name.text = UserDefaults.standard.value(forKey: "name") as! String
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        HUD.show(.progress)
        MCApi.sharedInstance().loadOrderList(){
            success , orderList in
            HUD.hide()
            if success {
                self.orders.removeAll()
                for order in orderList!{
                    self.orders.append(order)
                }
                
                self.tableView.reloadData()
            }else{
                self.showAlert(title: "", message: "Cannot connect to Server")
            }
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "splash") as! SplashViewController
        
        self.dismiss(animated: true, completion: nil)
        //present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as! CartCell
        
        let product = orders[indexPath.section].items[indexPath.row]
        
        cell.name.text = product.name
        
        let url = URL(string:  product.images[0].image)
        cell.productImage.kf.setImage(with: url)
        
        cell.price.text = "EURO \(product.price)"
        cell.quantity.text = String(product.quantity)
        return cell
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        // Dequeue with the reuse identifier
        let order = orders[section]
        
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
        let header = cell as! TableSectionHeader
        header.orderIdLable.text = String(order.id)
     
        header.orderTotalLable.text = String(order.display_total)
        
        
        return cell
        
    }
    
    
    func showAlert(title: String,message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    

   

   

}
