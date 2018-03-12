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
import PromiseKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let stocksDataModel = StocksDataModel()

    var jsonArray : Array<Array<String>> = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let STOCKS_URL = "https://www.alphavantage.co/query"
        let APP_ID = "YF4GKFKVSW54BMH4"
        let batchStockParams : [String : String] = ["function" : "BATCH_STOCK_QUOTES", "symbols" : "SIRI,AAPL,INTL", "apikey" : APP_ID]
        getStocksData(url: STOCKS_URL, parameters: batchStockParams)
        
    
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell")

//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            // your code here
//        }
    
//
        
        if self.jsonArray.count > 0 {
            cell?.textLabel?.text = self.jsonArray[indexPath.row].first
            cell?.detailTextLabel?.text = "fuck this shit"
        }
        
        return cell!
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jsonArray.count
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: Get Initial Stock Call
    /***************************************************************/

//    func getStocksData(url: String, parameters: [String : String]) {
//        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
//            response in
//
//            if response.result.isSuccess {
//
//                let result = response.result.value!
//                let stockJSON : JSON = JSON(result)
//                let stocksArray = self.updateStockData(json: stockJSON)
//                self.jsonResult = stocksArray
//
//            } else {
//
//                print("Error \(String(describing: response.result.error))")
//
//            }
//        }
//    }
    
    
    func getStocksData(url: String, parameters: [String : String]) -> Promise<JSON> {
        return Promise { fulfill in
            Alamofire.request(url, method: .get, parameters: parameters)
                .responseJSON { response in
                    if let result = response.result.value {
                        print("result")
                        let json = JSON(result)
                        self.jsonArray = self.updateStockData(json: json)
                        
                        self.tableView.reloadData()
                    } else {
                        print("Error")
                    }
                
            }
        }
    }
    
    //MARK: Updates Stocks and Parses JSON
    /***************************************************************/
    
    func updateStockData(json: JSON) -> Array<Array<String>> {
        
        var stocksArray : Array<Array<String>> = []

        for stock in 0..<json["Stock Quotes"].count {
            let stockSymbol = json["Stock Quotes"][stock]["1. symbol"].stringValue
            let stockPrice = json["Stock Quotes"][stock]["2. price"].doubleValue
            let stockPriceRounded = String(format: "%.2f", arguments: [stockPrice])
            stocksArray.append([stockSymbol, stockPriceRounded])
        }
        
        return stocksArray
    }
    
    

}

