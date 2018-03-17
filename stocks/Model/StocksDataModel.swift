//
//  StocksDataModel.swift
//  stocks
//
//  Created by Timothy Lee on 3/8/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

class StocksDataModel {

//    var stockInfo : Array<Array<String>> = []
//    var stockInfoOpenHighLow: Array<String> = []
//    var stockName : String
//    var stockHigh : Int
//    var stockLow : Int
//    var stockClose : Int
//    var stockOpen : Int
    
    var stocks: Array<Stock> = []

}

class Stock {
    var stockName : String
    var stockCurrent : Double?
    var stockHigh : Double?
    var stockLow : Double?
    var stockClose : Double?
    var stockOpen : Double?
    
    init?(stockName: String) {
        
        //Initialization should fail if name is empty
        guard !stockName.isEmpty else {
            return nil
        }
        
        self.stockName = stockName

    }
    
}

