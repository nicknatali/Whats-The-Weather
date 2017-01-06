//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Nick Natali on 12/24/2017.
//  Copyright © Make It Appen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //IBOutlets
    
    @IBOutlet var resultLabel: UILabel!
    
    @IBOutlet var textField: UITextField!
    
    @IBAction func submitBtn(_ sender: Any) {
        
        //Create URL
        if let url = URL(string: "http://www.weather-forecast.com/locations/" + textField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
        
            //Create HTTP Request
        let request = URLRequest(url: url)
        
            //Execute Request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data,response, error in
            
            var message = ""
            
            if error != nil {
                
                print(error)
                
            } else {
                
                if let unwrappedData = data {
                    
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    
                    //Disect HTML
                    var stringSeparator = "</span></a></li> </ol><p>"
                    
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if contentArray.count > 0 {
                            
                            stringSeparator = "</span>"
                            
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            
                            if newContentArray.count > 1 {
                                
                                //Replace Degree sign on label
                                message = newContentArray[0].replacingOccurrences(of: "%deg", with: "°")
                                
                                print(newContentArray[0])
                            }
                        }
                    }
                }
            }
            
            if message == "" {
                message = "Weather couldn't be found. please try again."
            }
            
            
            DispatchQueue.main.sync(execute:{
                self.resultLabel.text = message
            })
            
        }
        
        task.resume()
        } else {
            resultLabel.text = "Sorry, could not find that city, please try again"
        }
        
}
    
    
    
    //Allow users to touch outside of keyboard to hide
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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


