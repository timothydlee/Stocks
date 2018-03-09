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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let STOCKS_URL = "https://www.alphavantage.co/query"
        let APP_ID = "YF4GKFKVSW54BMH4"
        let batchStockParams : [String : String] = ["function" : "BATCH_STOCK_QUOTES", "symbols" : "MSFT,AAPL,INTL", "apikey" : APP_ID]
        let res = getStocksData(url: STOCKS_URL, parameters: batchStockParams)
        print(res)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell")
        
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let STOCKS_URL = "https://www.alphavantage.co/query"
//        let APP_ID = "YF4GKFKVSW54BMH4"
//        let batchStockParams : [String : String] = ["function" : "BATCH_STOCK_QUOTES", "symbols" : "MSFT,AAPL,INTL", "apikey" : APP_ID]
//
//        let result = getStocksData(url: STOCKS_URL, parameters: batchStockParams)
//
//        print(result)
        return 1
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: Get Initial Stock Call
    /***************************************************************/

    func getStocksData(url: String, parameters: [String : String])  {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            
            if response.result.isSuccess {
                
                let result = response.result.value!
                let stockJSON : JSON = JSON(result)
                let stocksArray = self.updateStockData(json: stockJSON)
                print(stocksArray)
                
            } else {
                
                print("Failed")
                
            }
            
        }
    }
    
    //MARK: Updates Stocks and Parses JSON
    /***************************************************************/
    
    func updateStockData(json: JSON) -> Array<Any> {

        var stocksArray = [] as Array

        for stock in 0..<json["Stock Quotes"].count {
            stocksArray.append(json["Stock Quotes"][stock])
        }
        

        return stocksArray
    }
    
    

}

