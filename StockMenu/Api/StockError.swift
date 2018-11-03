//
//  StockError.swift
//  StockMenu
//
//  Created by 王新 on 2018/11/2.
//  Copyright © 2018 Aaron. All rights reserved.
//

import Foundation

enum StockError:Int, Error {
    case UnKnow = -1
    case HttpSeverError = -2
    case InvalidError = -3
    
}
