//
//  StockDataModel.swift
//  StockMenu
//
//  Created by 王新 on 2018/10/31.
//  Copyright © 2018 Aaron. All rights reserved.
//

import Cocoa

class StockDataModel: NSObject {

    var name: String
    var code: String
    var value: String
    var increase: String
    var increaseRatio: String

//    index = 0, data = v_s_sz002841="51
//    index = 1, data = 视源股份
//    index = 2, data = 002841
//    index = 3, data = 61.95
//    index = 4, data = 1.95
//    index = 5, data = 3.25
//    index = 6, data = 17498
//    index = 7, data = 10845
//    index = 8, data = 406.07"
    /// 数据类型如上
    init(with stockData: Array<String>) {
        name = stockData[1]
        code = stockData[2]
        value = stockData[3]
        increase = stockData[4]
        increaseRatio = stockData[5]
    }
}
