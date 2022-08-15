//
//  CurrencyConverterViewController.swift
//  Wallet
//
//  Created by Krunal Shah on 2022-06-30.
//

import UIKit

class CurrencyConverterViewController: UIViewController {
    
    @IBOutlet weak var fromCountryButton: UIButton!
    @IBOutlet weak var toCountryButton: UIButton!
    
    @IBOutlet weak var amountTF: UITextField!
    
    
    @IBOutlet weak var convertedValueLabel: UILabel!
    @IBOutlet weak var currencyRateLabel: UILabel!
    
    @IBOutlet weak var convertedData: UILabel!
    @IBOutlet weak var currencyRate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func fromCountry(_ sender: UIButton) {
        let currencyMenu = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        currencyMenu.addAction(UIAlertAction(title: "AUD", style: .default) { _ in
            self.fromCountryButton.setTitle("AUD", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "CAD", style: .default) { _ in
            self.fromCountryButton.setTitle("CAD", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "CHF", style: .default) { _ in
            self.fromCountryButton.setTitle("CHF", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "CNF", style: .default) { _ in
            self.fromCountryButton.setTitle("CNF", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "EUR", style: .default) { _ in
            self.fromCountryButton.setTitle("EUR", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "GBP", style: .default) { _ in
            self.fromCountryButton.setTitle("GBP", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "HKD", style: .default) { _ in
            self.fromCountryButton.setTitle("HKD", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "INR", style: .default) { _ in
            self.fromCountryButton.setTitle("INR", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "JPY", style: .default) { _ in
            self.fromCountryButton.setTitle("JPY", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "NZD", style: .default) { _ in
            self.fromCountryButton.setTitle("NZD", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "USD", style: .default) { _ in
            self.fromCountryButton.setTitle("USD", for: .normal)
        })

        currencyMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(currencyMenu, animated: true)
    }
    
    
    @IBAction func toCountry(_ sender: UIButton) {
        let currencyMenu = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        currencyMenu.addAction(UIAlertAction(title: "AUD", style: .default) { _ in
            self.toCountryButton.setTitle("AUD", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "CAD", style: .default) { _ in
            self.toCountryButton.setTitle("CAD", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "CHF", style: .default) { _ in
            self.toCountryButton.setTitle("CHF", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "CNF", style: .default) { _ in
            self.toCountryButton.setTitle("CNF", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "EUR", style: .default) { _ in
            self.toCountryButton.setTitle("EUR", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "GBP", style: .default) { _ in
            self.toCountryButton.setTitle("GBP", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "HKD", style: .default) { _ in
            self.toCountryButton.setTitle("HKD", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "INR", style: .default) { _ in
            self.toCountryButton.setTitle("INR", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "JPY", style: .default) { _ in
            self.toCountryButton.setTitle("JPY", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "NZD", style: .default) { _ in
            self.toCountryButton.setTitle("NZD", for: .normal)
        })
        currencyMenu.addAction(UIAlertAction(title: "USD", style: .default) { _ in
            self.toCountryButton.setTitle("USD", for: .normal)
        })

        currencyMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(currencyMenu, animated: true)
    }
    
    @IBAction func convert(_ sender: UIButton) {
        
        func getUrl() -> URL? {
                    
                    
                   let url = "https://rates.hirak.site/rate.php?from=\(fromCountryButton.currentTitle ?? "USD")&to=\(toCountryButton.currentTitle ?? "INR")&token=7edea8513e7e8b89e894b7d027a3a611"
                    return URL(string: url)
                }
        
        //Step 1 Get URL
        
        guard let url = getUrl() else{
            print("Could not get data")
            
            return
        }
        
        //Step 2: create URLSession
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { data , response , error in
            print("Network call complete")
              
            guard  error == nil else {
                print("received error")
                return
            }
            
            guard let data = data else {
                print("data not found")
                return
            }

            // network call finished
              
            if  let converterStructure = parseJson(data: data) {
                print(converterStructure.rate!)
                
                DispatchQueue.main.async {
                    if let text = self.amountTF.text,
                       let number = Double (text){
                        if let rate = Double(converterStructure.rate ?? "1.0"){
                            print(number)
                            print(rate)
                            
                            let convertedBucks = number * rate
                                          
                            self.convertedData.text = "\(number) \(self.fromCountryButton.currentTitle ?? "USD") = \(round(convertedBucks*1000)/1000) \(self.toCountryButton.currentTitle ?? "INR")"
                            self.convertedData.isHidden = false
                            self.convertedValueLabel.isHidden = false
                            
                            print(convertedBucks)
                            
                            self.currencyRate.text = "1 \(self.fromCountryButton.currentTitle ?? "USD") = \(round(rate*1000)/1000)  \(self.toCountryButton.currentTitle ?? "INR")"
                            self.currencyRate.isHidden = false
                            self.currencyRateLabel.isHidden = false
                        }
                    }
                }
            }
        }
        
        //Step 4: Start the task
        dataTask.resume()
        
        func parseJson(data: Data) -> Converter? {
            let decoder = JSONDecoder()
            var converter: Converter?
           
            do {
                converter = try decoder.decode(Converter.self, from: data)
            } catch {
                print("Error parsing questions")
                print(error)
            }
            
            return converter
        }
    }
}

struct Converter: Decodable {
    let rate: String?
}
