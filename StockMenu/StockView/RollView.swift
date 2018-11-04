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
    var index = 0
    
    var timer: Timer?
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func updateStockDataArray(stockDataArray: Array<StockDataModel>) {
        print("updateStockDataArray count = \(stockDataArray.count)")
        mStockDataArray = stockDataArray
    }
    
    func startUpdateRollView() {
        print("startUpdateRollView")
        stopUpdateRollView()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { (timer) in
            DispatchQueue.main.async { [weak self] in
                self?.updateRollView()
            }
        }
    }
    
    private func updateRollView() {
        print("updateRollView index = \(index) count = \(mStockDataArray.count)")
        if mStockDataArray.count <= 0 {
            print(" stock data array is empty")
            return
        }
        if index < mStockDataArray.count - 1  {
            index += 1
        } else {
            index = 0
        }
        let stockDataModel = mStockDataArray[index]
        stockRollTextField.stringValue = "\(stockDataModel.description)"
    }
    
    func stopUpdateRollView() {
        guard timer != nil else {
            return
        }
        print("stopUpdateRollView")
        timer!.invalidate()
        timer = nil
    }
}
