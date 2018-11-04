//
//  AddStockWindowController.swift
//  StockMenu
//
//  Created by 王新 on 2018/11/3.
//  Copyright © 2018 Aaron. All rights reserved.
//

import Cocoa

protocol StockDelegate {
    func addStock(stock: String)
    func deleteSotck(stock: String)
}


class StockManagerWindowController: NSWindowController {
    
    @IBOutlet weak var codeTextFiled: NSTextField!
    
    @IBOutlet weak var codeManageTableView: NSTableView!
    
    @IBOutlet weak var stockErrorLabel: NSTextField!
    
    var stockList: Array<String>!
    var stockDelegate: StockDelegate?
    
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("StockManagerWindowController")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    
        stockList = getDefaultStockList()
        if stockList.count == 0 {
            stockList = DEFAULT_STOCK
        }
        initTableView()
        bindTextFieldChanged()
    }
    
    func initTableView() {
        codeManageTableView.delegate = self
        codeManageTableView.dataSource = self
        codeManageTableView.target = self
        codeManageTableView.layer?.borderWidth = 0
        codeManageTableView.selectionHighlightStyle = .none
        codeManageTableView.reloadData()
        
        codeManageTableView.action = #selector(deleteAction)
    }
    
    @objc func deleteAction() {
        // a判断点击的是删除
        if codeManageTableView.clickedColumn == 1 {
            let clickRow = codeManageTableView.clickedRow
            if clickRow == -1 {
                return
            }
            let deleteStock = stockList.remove(at: clickRow)
            codeManageTableView.reloadData()
            stockDelegate?.deleteSotck(stock: deleteStock)
        }
    }

    func bindTextFieldChanged() {
       codeTextFiled.delegate = self
    }
    
    func getDefaultStockList() -> Array<String> {
        let defaults = UserDefaults.standard
        return defaults.stringArray(forKey: STOCK_KEY) ?? DEFAULT_STOCK
    }

    @IBAction func addStockAction(_ sender: Any) {
        let stockStr = codeTextFiled.stringValue
        if stockList.contains(stockStr) {
            stockErrorLabel.stringValue = "编码重复"
            return
        }
        if  stockStr.count == 8 && (stockStr.starts(with: "sh") || stockStr.starts(with: "sz")) {
            stockDelegate?.addStock(stock: stockStr)
            stockList.append(stockStr)
            codeManageTableView.reloadData()
        } else {
            stockErrorLabel.stringValue = "编码错误"
        }
    }
}

extension StockManagerWindowController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let codeCell = NSUserInterfaceItemIdentifier("code")
        static let deleteCell = NSUserInterfaceItemIdentifier("delete")
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let stockCode = stockList[row]
        let stockDeleteImage = NSImage(named: "delete")
        
        var cellIdentifier: NSUserInterfaceItemIdentifier = CellIdentifiers.codeCell
        
        if tableColumn == tableView.tableColumns[0] {
            cellIdentifier = CellIdentifiers.codeCell
        } else if tableColumn == tableView.tableColumns[1] {
            cellIdentifier = CellIdentifiers.deleteCell
        }
        
        let view = tableView.makeView(withIdentifier: cellIdentifier, owner: nil)
        
        if let cellItem = view as? NSTableCellView {
            cellItem.textField?.stringValue = stockCode
            cellItem.imageView?.image = stockDeleteImage
            return cellItem
        }
        print("not table cell view return nil")
        return nil
    }
    
}

extension StockManagerWindowController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        print("numberOfRows stockDataList count = \(stockList.count) ")
        return stockList.count
    }
}

extension StockManagerWindowController: NSTextFieldDelegate {

    func controlTextDidChange(_ obj: Notification) {
        print("controlTextDidChange")
        stockErrorLabel.stringValue = ""
    }
}
