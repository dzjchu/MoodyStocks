//
//  ViewController.swift
//  MoodyStocks
//
//  Created by Dan Chu on 5/18/17.
//  Copyright © 2017 AlphaChron. All rights reserved.
//

import UIKit
import NaturalLanguageUnderstandingV1
import Foundation
class ViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Natural Lanaguage Understanding
        let username = "618ab670-193e-45ba-a9ec-66207f099279"
        let password = "1H6GGufcnMKM"
        let version = "2017-05-18"
        
        let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(username: username, password: password, version: version)
        
        let urlToAnalyze = "https://webhose.io/filterWebContent?token=fc746d99-b259-4b82-925e-8128046b5b0e&format=json&ts=1495055830238&sort=relevancy&q=UAL%20site_type%3Anews%20%20language%3Aenglish"
        getNumberOfPosts(urlToRequest: urlToAnalyze)
        
        
        let features = Features(concepts: ConceptsOptions(limit: 5), sentiment:SentimentOptions(document: true, targets: ["UAL"]))
        let parameters = Parameters(features: features, url: urlToAnalyze)
        
        let failure = { (error: Error) in print(error) }
        naturalLanguageUnderstanding.analyzeContent(withParameters: parameters, failure: failure) {
            results in 
            print (results)
        }
    
    }
    
//    // awesome
//    func getNumberOfPosts(urlInput: String){
//        let urlString = URL(string: urlInput)
//        if let url = urlString {
//            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if error != nil {
//                    print(error!)
//                } else {
//                    if let usableData = data {
//                        print(usableData)
//                        print(data)
////                        Data().base64EncodedString()
//                        print(usableData) //JSONSerialization
//                    }
//                }
//            }
//            task.resume()
//    }}
//    
    func getNumberOfPosts(urlToRequest: String){
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString = "data=Hello"
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("*****This is the data 4: \(dataString)") //JSONSerialization
            let totalResultsIndex = dataString?.range(of: "\"totalResults\": ", options: String.CompareOptions.backwards).location
            print(totalResultsIndex)
        }
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

