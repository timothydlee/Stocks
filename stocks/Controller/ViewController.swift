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
    
    let stocksDataModel = StocksDataModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let STOCKS_URL = "https://www.alphavantage.co/query"
        let APP_ID = "YF4GKFKVSW54BMH4"
        let batchStockParams : [String : String] = ["function" : "BATCH_STOCK_QUOTES", "symbols" : "INTL,SIRI,AAPL,MSFT,KBR,GOOGL,SNAP,JPM,AXP,AMZN", "apikey" : APP_ID]
        getStocksData(url: STOCKS_URL, parameters: batchStockParams)

    }
    
    //Requisite function of the UITableView controller that populates cells in each row, iterating over the counter, indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell")
        
        cell?.textLabel?.text = self.stocksDataModel.stockInfo[indexPath.row][0]
        cell?.detailTextLabel?.text = self.stocksDataModel.stockInfo[indexPath.row][1]
        
        return cell!
        
    }
    
    //Requisite function of the UITableView controller. Updates the TableView to contain as many rows as are returned - in this case, as many rows as exists in stocksDataModel.stockInfo
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stocksDataModel.stockInfo.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: Get Initial Stock Call
    /***************************************************************/
    //Function that uses Alamofire Cocoapod networking requests to request Alphavantage API.
    func getStocksData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in

            if response.result.isSuccess {

                guard let result = response.result.value else { return }
                let json = JSON(result)
                
                //Setting model to result of the JSON parsing function
                self.stocksDataModel.stockInfo = self.updateStockData(json: json)
                
                //.reloadData() calls to have the UITableView to reload. Because stocksDataModel is initiated as an empty array, the app would not recognize stocksDataModel as having any data populated in it, since the API call is asynchronous.
                self.tableView.reloadData()

            } else {

                print("Error \(String(describing: response.result.error))")

            }
        }
    }
    
    
    //MARK: Updates Stocks and Parses JSON using SwiftyJSON
    /***************************************************************/
    func updateStockData(json: JSON) -> Array<Array<String>> {
        
        var stocksArray : Array<Array<String>> = []

        for stock in 0..<json["Stock Quotes"].count {
            
            let stockSymbol = json["Stock Quotes"][stock]["1. symbol"].stringValue
            let stockPrice = json["Stock Quotes"][stock]["2. price"].doubleValue
            //Formatting the price which returns with many decimals to 2 places
            let stockPriceRounded = String(format: "%.2f", arguments: [stockPrice])
            stocksArray.append([stockSymbol, stockPriceRounded])
            
        }
        
        return stocksArray
        
    }
    
    //MARK: UITableViewCell styling
    /***************************************************************/
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColorFromHex(rgbValue: 0xf9f9f9)
    }
    
    
    //MARK: Function for using Hex Values for Color Styling
    /***************************************************************/
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    //MARK: Segue function to move screen to the search stocks screen.
    @IBAction func searchButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToSearchStocksScreen", sender: self)
    }
    
}

