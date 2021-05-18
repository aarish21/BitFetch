//
//  CoinManager.swift
//  BitFetch
//
//  Created by Aarish Rahman on 15/05/21.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8C71FE1B-E30E-4188-A9F6-8DF2CAF586E6"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?APIkey=\(apiKey)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data, response , error) in
                if error != nil{
                    
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData){
                        
                        let priceString = String(format: "%.2f", bitcoinPrice)
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
            let decoderData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decoderData.rate
            print(lastPrice)
            return lastPrice
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}
