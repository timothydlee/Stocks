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
    
    var stocks: Array<Stock> = []

}

class Stock {
    var stockName : String
    var stockCurrent : Double?
    var stockHigh : Double?
    var stockLow : Double?
    var stockClose : Double?
    var stockOpen : Double?
    
    //Only initializing stockName bc it is the only thing that is going to be saved to construct a Stock object and it will be used to identify the correct object.
    init?(stockName: String) {
        
        //Initialization should fail if name is empty
        guard !stockName.isEmpty else {
            return nil
        }
        
        self.stockName = stockName

    }
    
}

