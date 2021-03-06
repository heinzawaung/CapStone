//
//  ProductListViewController.swift
//  MCommerce
//
//  Created by Hein Zaw on 10/26/17.
//  Copyright © 2017 Hein Zaw. All rights reserved.
//

import UIKit
import RealmSwift
import PKHUD
import Kingfisher

class ProductListViewController: UIViewController,UITableViewDataSource ,UITableViewDelegate{
    
    
   
    @IBOutlet weak var productTableView: UITableView!
    

    var categoryPath : String?
    var categoryId : Int?
    
    let realm = try! Realm()
    
    var products: [Product]! = []

 
    
    override func viewDidLoad() {
      
        super.viewDidLoad()

       HUD.show(.progress)
        MCApi.sharedInstance().loadProductList(by: categoryPath!,categoryId: categoryId!){
            success , productList in
             HUD.hide()
            if success{
                self.products.removeAll()
                if let productList = productList {
                    for product in productList {
                        self.products.append(product)
                    }
                }
                
                self.productTableView.reloadData()
            }else{
                self.showAlert(title: "", message: "Cannot Connect To Server")
                let prods = try! self.realm.objects(Product.self).filter("categoryId == \(self.categoryId!)")
                for product in prods {
                    self.products.append(product)
                    
                }
                
                self.productTableView.reloadData()
            }
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        let product = products[indexPath.row]
        vc.proudctId = product.id
        vc.proudctPrice = product.display_price
        vc.productDescription = product.product_description
        vc.priceAmount = product.price
      
        for productImage in product.images {
            print(productImage)
            vc.productImages.append(productImage.image)
        }
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
        
        let product = products[indexPath.row]
        cell.name.text = product.name
        
        let url = URL(string:  product.images[0].image)
        cell.productImage.kf.setImage(with: url)
        
        cell.price.text = product.display_price
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func showAlert(title: String,message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
  
}
