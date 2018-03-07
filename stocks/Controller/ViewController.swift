//
//  ViewController.swift
//  stocks
//
//  Created by Timothy Lee on 3/5/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let STOCKS_URL = "https://www.alphavantage.co/query"
        let SYMBOL = "INTL"
        let INTERVAL = "60min"
        let APP_ID = "YF4GKFKVSW54BMH4"
        let initialStockParams : [String : String] = ["function" : "TIME_SERIES_DAILY", "symbol" : SYMBOL, "interval" : INTERVAL, "apikey" : APP_ID]
        let batchStockParams : [String : String] = ["function" : "BATCH_STOCK_QUOTES", "symbols" : "MSFT,AAPL,INTL", "apikey" : APP_ID]

//        getStocksData(url: STOCKS_URL, parameters: initialStockParams)
        getStocksData(url: STOCKS_URL, parameters: batchStockParams)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var stockLabel: UILabel!
    
    //MARK: Get Initial Stock Call
    /***************************************************************/

    func getStocksData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                let stockJSON : JSON = JSON(response.result.value!)
                self.updateStockData(json: stockJSON)
                
            } else {
                
                print("Failed")
                
            }
        }
    }
    
    //MARK: Updates Stocks and Parses JSON
    func updateStockData(json: JSON) {
        
        for stock in 0..<json["Stock Quotes"].count {
            print(json["Stock Quotes"][stock])
        }
        
    }

}

