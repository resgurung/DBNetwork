//
//  DBPagination.swift
//  TestApp (iOS)
//
//  Created by Robin Gurung on 03/08/2021.
//

import Foundation


public struct DBPagination {
    
    var pageValue: Int
    
    var pageKey: String
    
    var itemValue: Int
    
    var itemKey: String
    
    public init(pageKey: String,
                pageValue: Int,
                itemKey: String,
                itemValue: Int) {
        
        self.pageKey = pageKey
        
        self.pageValue = pageValue
        
        self.itemKey = itemKey
        
        self.itemValue = itemValue
    }
}
