//
//  SearchStockViewController.swift
//  
//
//  Created by Timothy Lee on 3/13/18.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchStockViewController: UIViewController {
    
    let STOCKS_URL = "https://www.alphavantage.co/query"
    let APP_ID = "YF4GKFKVSW54BMH4"
    
    //MARK: IBOutlets
    /***************************************************************/
    
    //IBOutlet defining stockModal that will appear and disappear.
    @IBOutlet weak var stockModal: UIView!
    
    //IBOutlet defining TextField that user inputs stock name
    @IBOutlet weak var searchStockTextField: UITextField!
    
    //IBOutlet representing the stockModal central constraint
    @IBOutlet weak var stockModalConstraint: NSLayoutConstraint!
    
    //IBOutlet for background button that's screen sized, allows user to dismiss popup once done with it in addition to being able to close out from "Close" Button.
    @IBOutlet weak var backgroundButton: UIButton!
    
    //IBOutlet for labels with stock name, high, low, opening and closing prices in the modal
    @IBOutlet weak var stockModalStockName: UILabel!
    @IBOutlet weak var stockModalStockHigh: UILabel!
    @IBOutlet weak var stockModalStockLow: UILabel!
    @IBOutlet weak var stockModalStockOpen: UILabel!
    @IBOutlet weak var stockModalCurrentStockPrice: UILabel!
    
    //MARK: IBActions
    /***************************************************************/
    
    //IBAction defining when the back button is pressed, which sends user back to main screen
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goBackToMainScreen", sender: self)
    }
    
    //IBAction defining when the close button is pressed, which dismisses the stock modal
    @IBAction func closeButtonPressed(_ sender: Any) {
        modalOff()
        resetModal()
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Gives modal rounded corners
        stockModal.layer.cornerRadius = 8
        
    }
    
    //MARK: searchForStockButtonPressed initiates action for when user puts in stock ticker symbol to search.
    /***************************************************************/
    
    //IBAction that initiates search for stock that user inputs
    @IBAction func searchForStockButtonPressed(_ sender: Any) {
        
        if self.searchStockTextField.text == "" {
            
            shake()
            
        } else if let searchInput = searchStockTextField.text {
            
            modalOn()
            
            let yesterdayClosePriceParams : [String : String] = ["function" : "TIME_SERIES_DAILY", "symbol" : searchInput, "apikey" : APP_ID]
            let latestPriceParams : [String : String] = ["function" : "TIME_SERIES_INTRADAY", "symbol" : searchInput, "interval" : "1min", "apikey" : APP_ID]
            self.checkLatestPrice(url: STOCKS_URL, parametersCurrent: latestPriceParams, parametersPrevDay: yesterdayClosePriceParams)
            
        }
    }
    
    //MARK: checkLatestPrice is function that takes user input of a stock symbol and makes API call for Alphavantage's INTRADAY series of information of 1 min refresh intervals to check the current price. Additionally, a call is made ot the TIME SERIES DAILY function which and checks the overall day's open, highs and lows.
    /***************************************************************/
    
    func checkLatestPrice(url: String, parametersCurrent: [String : String], parametersPrevDay: [String : String]) {
        
        Alamofire.request(url, method: .get, parameters: parametersCurrent).responseJSON {
            response in
            
            if response.result.isSuccess {
                
                //Parsing JSON result from the Intraday API Call from Alphavantage
                guard let result = response.result.value else { return }
                let json = JSON(result)
                
                let stockName = String(describing: json["Meta Data"]["2. Symbol"])
                self.stockModalStockName.text = stockName
                
                let lastRefreshTime = String(describing: json["Meta Data"]["3. Last Refreshed"])
                let lastRefreshTimeJSON = json["Time Series (1min)"][lastRefreshTime]
                
                let currentPrice = lastRefreshTimeJSON["4. close"].doubleValue
                let currentPriceRounded = String(format: "%.2f", arguments: [currentPrice])
                self.stockModalCurrentStockPrice.text = "$\(currentPriceRounded)"

            } else {
                
                print("Error \(String(describing: response.result.error))")
                
            }
            
        }
        
        Alamofire.request(url, method: .get, parameters: parametersPrevDay).responseJSON {
            response in
            
            if response.result.isSuccess {
                
                guard let result = response.result.value else { return }
                let json = JSON(result)
                var lastRefreshTime = String(describing: json["Meta Data"]["3. Last Refreshed"])
                
                //During an active trading day, in order to get the key in the dictionary formatted correctly, need to remove the timestamp after the date. This does that.
                if let lastRefreshTimeFormatted = lastRefreshTime.range(of: " ") {
                    lastRefreshTime.removeSubrange(lastRefreshTimeFormatted.lowerBound..<lastRefreshTime.endIndex)
                    print(lastRefreshTimeFormatted)
                }

                let stockModalOpen = json["Time Series (Daily)"][lastRefreshTime]["1. open"].doubleValue
                let stockModalOpenFormatted = String(format: "%.2f", arguments: [stockModalOpen])
                self.stockModalStockOpen.text = "Open: $\(stockModalOpenFormatted)"
                
                let stockModalHigh = json["Time Series (Daily)"][lastRefreshTime]["2. high"].doubleValue
                let stockModalHighFormatted = String(format: "%.2f", arguments: [stockModalHigh])
                self.stockModalStockHigh.text = "High: \(stockModalHighFormatted)"
                
                let stockModalLow = json["Time Series (Daily)"][lastRefreshTime]["3. low"].doubleValue
                let stockModalLowFormatted = String(format: "%.2f", arguments: [stockModalLow])
                self.stockModalStockLow.text = "High: \(stockModalLowFormatted)"
                
            } else {
                
                print("Error \(String(describing: response.result.error))")
                
            }
        }
        
    }
    
    //MARK: Shake animation function
    /***************************************************************/
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.searchStockTextField.center.x - 10, y: self.searchStockTextField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.searchStockTextField.center.x + 10, y: self.searchStockTextField.center.y))
        self.searchStockTextField.layer.add(animation, forKey: "position")
    }
    
    //MARK: Animation for when the modal pops up when the search stock text field is properly filled and the search button is pressed.
    /***************************************************************/
    
    func modalOn() {
        //If text field is not empty, the modal shows up.
        stockModalConstraint.constant = 0
        
        //Changes alpha setting to 0.5, which causes background behind modal to dim.
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundButton.alpha = 0.5
        })
        
        //Animation to slide in the modal over 0.2s.
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    //MARK: Modal animation to dismiss the modal once the user is done.
    /***************************************************************/
    
    func modalOff() {
        stockModalConstraint.constant = -400
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
        })
    }
    
    //MARK: Function that resets the modal text if user wants to check a different stock.
    /***************************************************************/
    
    func resetModal() {
        self.stockModalStockName.text = ""
        self.stockModalStockHigh.text = ""
        self.stockModalStockLow.text = ""
        self.stockModalStockOpen.text = ""
        self.stockModalCurrentStockPrice.text = ""
    }

}
