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
    
    var thereIsCellTapped = false
    var selectedRowIndex = -1
    let STOCKS_URL = "https://www.alphavantage.co/query"
    let APP_ID = "YF4GKFKVSW54BMH4"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let batchStockParams : [String : String] = ["function" : "BATCH_STOCK_QUOTES", "symbols" : "INTL,SIRI,AAPL,MSFT,KBR,GOOGL,SNAP,JPM,AXP,AMZN", "apikey" : APP_ID]
        
        getStocksData(url: STOCKS_URL, parameters: batchStockParams)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Requisite function of the UITableView controller that populates cells in each row, iterating over the counter, indexPath
    /***************************************************************/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! customCell
        let stock = self.stocksDataModel.stocks[indexPath.row]
        cell.firstViewTitleLabel.text = stock.stockName
        if let currentPrice = stock.stockCurrent {
            cell.firstViewDetailLabel.text = "$\(currentPrice)"
        }
        
        if let currentOpen = stock.stockOpen {
            cell.secondViewOpen.text = "$\(currentOpen)"
        }
        
        if let currentHigh = stock.stockHigh {
            cell.secondViewHigh.text = "$\(currentHigh)"
        }
        
        if let currentLow = stock.stockLow {
            cell.secondViewLow.text = "$\(currentLow)"
        }
        
        return cell
    }
    
    //MARK: UITableView function that points at which row was selected and then if tapped, expands that row.
    /***************************************************************/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let symbol = self.stocksDataModel.stocks[indexPath.row].stockName
        print("clicked: " + symbol)
        let params : [String : String] = ["function" : "TIME_SERIES_DAILY", "symbol" : symbol, "apikey" : APP_ID]
        
        getIndividualStockInfo(url: STOCKS_URL, parameters: params, symbol: symbol)
        
        if(selectedRowIndex == indexPath.row) {
            selectedRowIndex = -1
        } else {
            selectedRowIndex = indexPath.row
        }
        
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        self.tableView.endUpdates()
        
    }
    
    //MARK: Requisite function of the UITableView controller. Updates the TableView to contain as many rows as are returned - in this case, as many rows as exists in stocksDataModel.stockInfo
    /***************************************************************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stocksDataModel.stocks.count
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
    
    //MARK: Tableview function that sets the height of the row of a cell
    /***************************************************************/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (selectedRowIndex == indexPath.row) {
            return 132
        }
        return 44
        
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
                self.stocksDataModel.stocks = self.updateStockData(json: json)
                
                //.reloadData() calls to have the UITableView to reload. Because stocksDataModel is initiated as an empty array, the app would not recognize stocksDataModel as having any data populated in it, since the API call is asynchronous.
                self.tableView.reloadData()

            } else {

                print("Error \(String(describing: response.result.error))")

            }
        }
    }
    
    //MARK: Updates Stocks and Parses JSON using SwiftyJSON
    /***************************************************************/
    func updateStockData(json: JSON) -> Array<Stock> {
        
        var stocksArray : Array<Stock> = []

        for stock in 0..<json["Stock Quotes"].count {
            
            
            let stockSymbol = json["Stock Quotes"][stock]["1. symbol"].stringValue
            let stockPrice = json["Stock Quotes"][stock]["2. price"].doubleValue
            //Formatting the price which returns with many decimals to 2 places
            let stockPriceRounded = String(format: "%.2f", arguments: [stockPrice])
            guard let stockObj = Stock(stockName: stockSymbol) else { continue }
            stockObj.stockCurrent = Double(stockPriceRounded)
            stocksArray.append(stockObj)
            
        }
        
        return stocksArray
        
    }
    
    //MARK: Get Individual Stock upon Click from API
    /***************************************************************/
    func getIndividualStockInfo(url: String, parameters: [String : String], symbol: String) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in

            if response.result.isSuccess {

                guard let result = response.result.value else { return }
                let json = JSON(result)
                
                print(symbol)
                var stockObj : Stock?
                for stock in self.stocksDataModel.stocks {
                    if stock.stockName == symbol {
                        stockObj = stock
                        break
                    }
                }
                self.updatesThings(json: json, stockObj: stockObj!)
                

//                var lastRefreshTime = String(describing: json["Meta Data"]["3. Last Refreshed"])
//
//                //During an active trading day, in order to get the key in the dictionary formatted correctly, need to remove the timestamp after the date. This does that.
//                if let lastRefreshTimeFormatted = lastRefreshTime.range(of: " ") {
//                    lastRefreshTime.removeSubrange(lastRefreshTimeFormatted.lowerBound..<lastRefreshTime.endIndex)
//                }
//
//                let stockOpen = json["Time Series (Daily)"][lastRefreshTime]["1. open"].doubleValue
//                let stockOpenFormatted = String(format: "%.2f", arguments: [stockOpen])
//
//                let stockHigh = json["Time Series (Daily)"][lastRefreshTime]["2. high"].doubleValue
//                let stockHighFormatted = String(format: "%.2f", arguments: [stockHigh])
//
//                let stockLow = json["Time Series (Daily)"][lastRefreshTime]["3. low"].doubleValue
//                let stockLowFormatted = String(format: "%.2f", arguments: [stockLow])
//                arrayInfo.append(stockOpenFormatted)
//                arrayInfo.append(stockHighFormatted)
//                arrayInfo.append(stockLowFormatted)


                self.tableView.reloadData()


            } else {

                print("Error \(String(describing: response.result.error))")

            }


        }
        
    }
    
    func updatesThings(json: JSON, stockObj: Stock) {
        
        var lastRefreshTime = String(describing: json["Meta Data"]["3. Last Refreshed"])
        
        //During an active trading day, in order to get the key in the dictionary formatted correctly, need to remove the timestamp after the date. This does that.
        if let lastRefreshTimeFormatted = lastRefreshTime.range(of: " ") {
            lastRefreshTime.removeSubrange(lastRefreshTimeFormatted.lowerBound..<lastRefreshTime.endIndex)
        }
        
        let stockOpen = json["Time Series (Daily)"][lastRefreshTime]["1. open"].doubleValue
        let stockOpenFormatted = String(format: "%.2f", arguments: [stockOpen])
        
        let stockHigh = json["Time Series (Daily)"][lastRefreshTime]["2. high"].doubleValue
        let stockHighFormatted = String(format: "%.2f", arguments: [stockHigh])
        
        let stockLow = json["Time Series (Daily)"][lastRefreshTime]["3. low"].doubleValue
        let stockLowFormatted = String(format: "%.2f", arguments: [stockLow])
        
        stockObj.stockOpen = Double(stockOpenFormatted)
        stockObj.stockHigh = Double(stockHighFormatted)
        stockObj.stockLow = Double(stockLowFormatted)
        
    }
    
    //MARK: Segue function to move screen to the search stocks screen.
    /***************************************************************/
    @IBAction func searchButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToSearchStocksScreen", sender: self)
    }
    
}

