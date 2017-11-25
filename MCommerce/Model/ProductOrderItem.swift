//
//  ProductOrderItem.swift
//  MCommerce
//
//  Created by Hein Zaw on 11/24/17.
//  Copyright © 2017 Hein Zaw. All rights reserved.
//

import Foundation

class ProductOrderImage {
    var image :String = ""
}

class ProductOrderItem{
    
    var id :Int = 0
    var has_variants :Int = 0
    var name :String = ""
    var display_price : String = ""
    var product_description :String = ""
    var price :Int = 0
    var quantity :Int = 0
    var images = [ProductOrderImage]()
    
    
}
