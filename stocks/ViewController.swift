//
//  ViewController.swift
//  stocks
//
//  Created by Timothy Lee on 3/5/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let STOCKS_URL = "https://www.alphavantage.co/query"
        let STOCKS_FUNCTION = "TIME_SERIES_DAILY"
        let SYMBOL = "INTL"
        let INTERVAL = "60min"
        let APP_ID = "YF4GKFKVSW54BMH4"
        let params : [String : String] = ["function" : STOCKS_FUNCTION, "symbol" : SYMBOL, "interval" : INTERVAL, "apikey" : APP_ID]

        getStocksData(url: STOCKS_URL, parameters: params)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getStocksData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if let json = response.result.value {
                print("\(url)\(parameters)")
                print("JSON: \(json)")
            } else {
                print("Failed")
            }
        }
    }


}

