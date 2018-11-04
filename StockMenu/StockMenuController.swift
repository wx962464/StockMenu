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
let DEFAULT_STOCK = ["sz002841"]
class StockMenuController: NSObject {

    @IBOutlet weak var stockMenu: NSMenu!

    @IBOutlet weak var stockDataView: StockView!
    @IBOutlet weak var stockRollView: RollView!
    
    @IBOutlet weak var upateMenuItem: NSMenuItem!
    @IBOutlet weak var hideRollMenuItem: NSMenuItem!
    
    var stockManagerWindowController: StockManagerWindowController!
    
    var stockDataItem: NSMenuItem!
    let stockButtonItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let stockRollItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var stockDataLists = Array<StockDataModel>()
    
    let stockApi = StockApi()
    var disposeBag = DisposeBag()
    
    var isUpdate = true
    var stockTimer: Timer?
    var stockList = DEFAULT_STOCK
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 添加StockMenu
        let icon = NSImage(named: "Stock")
        icon?.isTemplate = true // best for dark mode
        stockButtonItem.button?.image = icon
        stockButtonItem.menu = stockMenu
        stockButtonItem.button?.toolTip = "股票数据"
        
        // 设置 StockMenu 中 stockData 的自定义View
        stockDataItem = stockMenu.item(withTitle: "stockData")!
        stockDataItem.view = stockDataView
        
        //添加长条数据信息
        stockRollItem.view = stockRollView
        stockRollItem.isVisible = true
     
        // 加载StockManager Window
        stockManagerWindowController = StockManagerWindowController()
        stockManagerWindowController.stockDelegate = self
        
        // 加载之前保存的stock
        let defaults = UserDefaults.standard
        stockList = defaults.stringArray(forKey: STOCK_KEY) ?? DEFAULT_STOCK
        if stockList.count == 0 {
            stockList = DEFAULT_STOCK
        }
        //默认启动轮训查询，及长条数据显示
        startStockDataUpdate()
        stockRollView.startUpdateRollView()
    }
    
    func getStockData() {
        
        stockApi.getStockDataApi(stockList: stockList).subscribeOn(MainScheduler.instance).subscribe(
            onNext: { [weak self] stockModelArray in
                self?.stockDataView.stockDataList = stockModelArray
                if self?.stockRollItem.isVisible ?? false {
                    self?.stockRollView.updateStockDataArray(stockDataArray: stockModelArray)
                }
            },
            onError: { (error) in
                print("get stockData fail error = \(error) ")
            }).disposed(by: disposeBag)
    }
    
    func startStockDataUpdate() {
        stopStockDataUpdata()
        stockTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            DispatchQueue.main.async { [weak self] in
                self?.getStockData()
            }
        }
    }
    
    func stopStockDataUpdata() {
        guard stockTimer != nil else {
            return
        }
        print("stopStockDataUpdata")
        stockTimer!.invalidate()
        stockTimer = nil
    }
    @IBAction func updateStock(_ sender: Any) {
        print("update stock")
        isUpdate = !isUpdate
        upateMenuItem.title = isUpdate ? "停止更新" : "开始更新"
        if isUpdate {
            startStockDataUpdate()
             stockRollView.startUpdateRollView()
        } else {
            stopStockDataUpdata()
            stockRollView.stopUpdateRollView()
        }
    }
    
    @IBAction func hideRollView(_ sender: Any) {
        stockRollItem.isVisible = !stockRollItem.isVisible
        hideRollMenuItem.title = stockRollItem.isVisible ? "隐藏横栏" : "显示横栏"
        if stockRollItem.isVisible {
            stockRollView.startUpdateRollView()
        } else {
             stockRollView.stopUpdateRollView()
        }
    }
    
    @IBAction func addStock(_ sender: Any) {
        print("add stock")
        stockManagerWindowController.showWindow(nil)
        stockManagerWindowController.window?.makeKey()
    }
    
    @IBAction func quitApp(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
}
extension StockMenuController: StockDelegate {
    
    func addStock(stock: String) {
        print("add stock \(stock)")
        stockList.append(stock)
        saveStockList()
    }
    func deleteSotck(stock: String) {
        print("delete stock \(stock)")
        if let index = stockList.firstIndex(of: stock) {
             stockList.remove(at: index)
            print("delete stock \(stock) success ")
            saveStockList()
        } else {
            print("delete stock not found")
        }
        saveStockList()
    }
    
    func saveStockList() {
        let defaults = UserDefaults.standard
        defaults.set(stockList, forKey: STOCK_KEY)
    }
}
