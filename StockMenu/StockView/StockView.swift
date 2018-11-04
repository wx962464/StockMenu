//
//  StockView.swift
//  StockMenu
//
//  Created by 王新 on 2018/10/31.
//  Copyright © 2018 Aaron. All rights reserved.
//

import Cocoa

class StockView: NSView {

    @IBOutlet weak var stockTableView: NSTableView!
    
    var stockDataList = Array<StockDataModel>() {
        didSet {
            stockTableView.reloadData()
        }
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        DispatchQueue.main.async {
            self.initView()
        }
    }
    
    func initView() {
        stockTableView.delegate = self
        stockTableView.dataSource = self
        stockTableView.target = self
        stockTableView.layer?.borderWidth = 0
        stockTableView.selectionHighlightStyle =  .none
    }
    
}
extension StockView: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let nameCell = NSUserInterfaceItemIdentifier("name")
        static let codeCell = NSUserInterfaceItemIdentifier("code")
        static let valueCell = NSUserInterfaceItemIdentifier("value")
        static let increaseCell = NSUserInterfaceItemIdentifier("increase")
        static let increaseRatioCell = NSUserInterfaceItemIdentifier("increaseRatio")
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = stockDataList[row]
        var value: String = ""
        var cellIdentifier: NSUserInterfaceItemIdentifier = CellIdentifiers.nameCell
        if tableColumn == tableView.tableColumns[0] {
            value = item.name
            cellIdentifier = CellIdentifiers.nameCell
        } else if tableColumn == tableView.tableColumns[1] {
            value = item.code
            cellIdentifier = CellIdentifiers.codeCell
        } else if tableColumn == tableView.tableColumns[2] {
           value = item.value
            cellIdentifier = CellIdentifiers.valueCell
        } else if tableColumn == tableView.tableColumns[3] {
            value = item.increase
            cellIdentifier = CellIdentifiers.increaseCell
        } else if tableColumn == tableView.tableColumns[4] {
            value = item.increaseRatio
            cellIdentifier = CellIdentifiers.increaseRatioCell
        }

        let view = tableView.makeView(withIdentifier: cellIdentifier, owner: nil)

        if let cellItem = view as? NSTableCellView {
            cellItem.textField?.stringValue = value
            return cellItem
        }
        print("not table cell view return nil")
        return nil
    }
    
}

extension StockView: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return stockDataList.count
    }
}
