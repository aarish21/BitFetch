//
//  ViewController.swift
//  BitFetch
//
//  Created by Aarish Rahman on 15/05/21.
//

import UIKit

class ViewController: UIViewController{
    var coinManager = CoinManager()
    
    
    

    @IBOutlet var currencyPicker: UIPickerView!
    @IBOutlet var inputLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self 
    }
    
   
}

//MARK:- CoinManagerDelegate

extension ViewController: CoinManagerDelegate{
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.inputLabel.text = price
            self.currencyLabel.text = currency
        }
  
    }
    func didFailWithError(error: Error) {
            print(error)
        }
}

//MARK:- UIPickerView DataSource & Delegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

