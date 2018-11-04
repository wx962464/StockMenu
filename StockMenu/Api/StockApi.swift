//
//  StockApi.swift
//  StockMenu
//
//  Created by 王新 on 2018/11/2.
//  Copyright © 2018 Aaron. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

let STOCK_ADDRESS = "http://qt.gtimg.cn/q="
let STOCK_SPLIT: Character = ";"
let STOCK_VALUE_SPLIT: Character = "~"

class StockApi {
    
    func getStockDataApi(stockList: Array<String>) -> Observable<Array<StockDataModel>> {
        var requestRealAddr = STOCK_ADDRESS
        for (index,str) in stockList.enumerated() {
            if index == 0 {
                requestRealAddr += "s_\(str)"
            } else {
                requestRealAddr += ",s_\(str)"
            }
        }
        return request(requestRealAddr).map({ (stockDetailStr) -> Array<StockDataModel> in
            
            var stockModelArray = Array<StockDataModel>()
            let stockArray = (stockDetailStr as! String).split(separator: STOCK_SPLIT).filter { $0.count > 0 }
            for stockStrData in stockArray {
                let stockDataArray = stockStrData.split(separator: STOCK_VALUE_SPLIT).map { return String($0) }
                if stockDataArray.count > 5 {
                    stockModelArray.append(StockDataModel(with: stockDataArray))
                }
            }
            return stockModelArray
        })
    }
    
    private func request(_ address: String,
                          method: HTTPMethod = .get,
                          parameters: Dictionary<String, String>? = nil,
                          headers: Dictionary<String, String>? = nil,
                          encoding: ParameterEncoding = URLEncoding.default,
                          needsQueryString: Bool = false) -> Observable<Any> {
        return Observable.create { observable in
            Alamofire.request(address, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .responseString { response in
                    switch response.result {
                    case .success(let value):
                        print("get sotck data success: \(value)")
                        if let status = response.response?.statusCode {
                            if status >= 300 {
                                observable.onError(StockError.HttpSeverError)
                            } else {
                                observable.onNext(value)
                            }
                        } else {
                            observable.onNext(StockError.UnKnow)
                        }
                    case .failure(let error):
                        print("request fail error = \(error)")
                        observable.onError(StockError.InvalidError)
                    }
                    observable.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
