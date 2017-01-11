//
//  ViewController.swift
//  Weather App
//
//  Created by Liz Healy on 1/10/17.
//  Copyright © 2017 netGalaxyStudios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherText: UITextField!
    
    @IBOutlet weak var weatherUpdate: UILabel!
    
    @IBAction func searchButton(_ sender: Any) {
        
        let theCity = weatherText.text
        
        let city = theCity?.replacingOccurrences(of: " ", with: "-")
        
        if city == "" {
            weatherUpdate.text = "Please enter a city"
        }
        
        else {
            
            var message = ""
        
            let cityUrl = "http://www.weather-forecast.com/locations/" + city! + "/forecasts/latest"
        
            if let url = URL(string: cityUrl) {
                
                let request = NSMutableURLRequest(url: url)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    if error != nil {
                        print(error)
                    }
                    else {
                        if let unwrappedData = data {
                            let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                            
                            let intro = "3 Day Weather Forecast Summary"
                            if (dataString?.contains(intro))! {
                                
                                if let contentArray = dataString?.components(separatedBy: "3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">") {
                                    //print(contentArray[1])
                                    
                                    if contentArray.count > 1 {
                                        let newContent = contentArray[1].components(separatedBy: "</")
                                        
                                        if newContent.count > 1 {
                                            
                                            message = newContent[0].replacingOccurrences(of: "&deg;", with: "°")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if message == "" {
                        message = "The Weather could not be found, please try again"
                    }
                    DispatchQueue.main.sync(execute: {
                        //UpdateUI
                        self.weatherUpdate.text = message
                    })
                    
                }
            task.resume()
            
            }
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

