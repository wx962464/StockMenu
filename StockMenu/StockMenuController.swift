//
//  StockMenuController.swift
//  StockMenu
//
//  Created by 王新 on 2018/10/30.
//  Copyright © 2018 Aaron. All rights reserved.
//

import Cocoa
import RxSwift

let STOCK_KEY = "stock_key"
let DEFAULT_STOCK = ["002841"]
class StockMenuController: NSObject {

    @IBOutlet weak var stockMenu: NSMenu!

    @IBOutlet weak var stockDataView: StockView!
    @IBOutlet weak var stockRollView: RollView!
    
    @IBOutlet weak var upateMenuItem: NSMenuItem!
    @IBOutlet weak var hideRollMenuItem: NSMenuItem!
    
    var stockDataItem: NSMenuItem!
    
    let stockButtonItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let stockRollItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var stockDataLists = Array<StockDataModel>()
    
    let stockApi = StockApi()
    var disposeBag = DisposeBag()
    
    var isUpdate = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let icon = NSImage(named: "Stock")
        icon?.isTemplate = true // best for dark mode
        stockButtonItem.button?.image = icon
        stockButtonItem.menu = stockMenu
        stockButtonItem.button?.toolTip = "股票数据"
        
        stockDataItem = stockMenu.item(withTitle: "stockData")!
        stockDataItem.view = stockDataView
        
        //添加长条数据信息
        stockRollItem.view = stockRollView
     
        let defaults = UserDefaults.standard
        let stockList = defaults.stringArray(forKey: STOCK_KEY) ?? DEFAULT_STOCK
        
        stockApi.getStockDataApi(stockList: stockList).subscribe(
            onNext: { [weak self] stockModelArray in
                print("get stockData success  array = \(stockModelArray)")
                self?.stockDataView.stockDataList = stockModelArray
            },
            onError: { (error) in
                print("get stockData fail error = \(error) ")
            }).disposed(by: disposeBag)
//        stockView.stockDataList = stockDataLists

    }
    
    @IBAction func updateStock(_ sender: Any) {
        print("update stock")
        isUpdate = !isUpdate
        upateMenuItem.title = isUpdate ? "停止更新" : "开始更新"
    }
    
    @IBAction func hideRollView(_ sender: Any) {
        stockRollItem.isVisible = !stockRollItem.isVisible
        hideRollMenuItem.title = stockRollItem.isVisible ? "隐藏横栏" : "显示横栏"
    }
    
    @IBAction func addStock(_ sender: Any) {
        print("add stock")
    }
    
    @IBAction func quitApp(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
}
