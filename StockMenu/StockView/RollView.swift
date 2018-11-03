//
//  RollView.swift
//  StockMenu
//
//  Created by 王新 on 2018/11/2.
//  Copyright © 2018 Aaron. All rights reserved.
//

import Cocoa

class RollView: NSView {
    
    @IBOutlet weak var stockRollTextField: NSTextField!
    
    var mStockDataArray = Array<StockDataModel>()
    var stockCount = 0
    var index = 0
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        DispatchQueue.main.async {
            self.stockRollTextField.stringValue = "视源股份 002841 62.11 2.3  3.9%"
        }
    }
    
    func updateDataArray(stockDataArray: Array<StockDataModel>) {
        mStockDataArray = stockDataArray
        stockCount = stockDataArray.count
    }
}
