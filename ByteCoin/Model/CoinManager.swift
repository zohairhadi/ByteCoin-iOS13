//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
//    let baseURL = "https://rest.coinapi.io/v1/exchangerate/?appid=YOUR_APP_ID"
    let apiKey = "YOUR_API_KEY"
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        
//        make final url by concatinating curreny to baseurl
        let urlString = baseURL + currency
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }

                if let safeData = data{
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.1f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            print(decodedData.last)
            return decodedData.last
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
