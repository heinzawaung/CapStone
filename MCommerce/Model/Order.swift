//
//  Order.swift
//  MCommerce
//
//  Created by Hein Zaw on 11/24/17.
//  Copyright © 2017 Hein Zaw. All rights reserved.
//

import Foundation

import Foundation
import RealmSwift

class Order
    
{
    var id :Int = 0
    var display_total :String = ""
    var quantity :Int = 0
  
    
    var items = [ProductOrderItem]()
    
    
}
