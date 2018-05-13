//
//  ViewController.swift
//  FetchJSON
//
//  Created by jcliu on 2018/5/13.
//  Copyright © 2018年 CSIE NCNU. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDataDelegate {


    @IBOutlet var keyword: UITextView!
    @IBOutlet var resultTextView: UITextView!
    
    @IBAction func searchButton(_ sender: UIButton) {
        let key = keyword.text
        print(key!)
        
        var urlComponents: URLComponents = URLComponents(string: "https://www.tbn.org.tw")!
        urlComponents.path = "/api/v1/occurrence"
        urlComponents.queryItems = [URLQueryItem(name: "scientificName", value: key!), URLQueryItem(name:"eventPlaceAdminarea", value:"南投縣")]
        let searchURL = urlComponents.url!
        print(searchURL)
        
        let config = URLSessionConfiguration.default
        var session: URLSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        session.dataTask(with: searchURL, completionHandler: { (data, urlResponse, error) in
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let count = json!["count"] as? Int {
                            print("count=\(count)")
                        }
                        var showResult: String = ""
                        if let results = json!["results"] as? [AnyObject]{
                            for result in results {
                                if let latitude = result["decimalLatitude"] {
                                    showResult += "lat = \(latitude!), "
                                    print("lat = \(latitude!), ", terminator:"")
                                }
                                if let longitude = result["decimalLongitude"] {
                                    showResult += "lon = \(longitude!)\n"
                                    print("lon = \(longitude!)")
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.resultTextView.text = showResult
                        }
                    }
                }).resume()
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

