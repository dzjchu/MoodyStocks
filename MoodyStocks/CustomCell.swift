//
//  CustomCell.swift
//  MoodyStocks
//
//  Created by Istvan on 5/19/17.
//  Copyright © 2017 AlphaChron. All rights reserved.
//

import UIKit
import NaturalLanguageUnderstandingV1
import Foundation

class CustomCell: UITableViewCell {
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var percentLabel: UILabel!
    var symbol: String = ""
    var numsDict : Dictionary<String, Int> = Dictionary()
    let green = UIColor(red:0.33, green:0.76, blue:0.37, alpha:1.0)
    let red = UIColor(red:0.82, green:0.33, blue:0.33, alpha:1.0)
    
    func updateProgressBar(withRatio: Float){
        print("ProgressBar --> \(withRatio)")
        
        DispatchQueue.main.async {
            
            if withRatio < 0.25{
                let percent = Int(withRatio + 0.5 * 100)
                self.percentLabel.text = String("\(percent)%")
                self.progressBar.setProgress(withRatio + 0.5, animated: true)
            }else {
                let percent = Int(withRatio * 100)
                self.percentLabel.text =  String("\(percent)%")
                self.progressBar.setProgress(withRatio, animated: true)
            }
        }
    }
    
    //1: get number of articles
    //2: Call Watson
    //3: Update progessBar
    //4: Update mood
    func setBgColor(Color: UIColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0)){
        self.leftView.backgroundColor = Color
    }
    
    func getNumberOfNewsCounts(term: String){
        let urlShort = "https://webhose.io/filterWebContent?token=fc746d99-b259-4b82-925e-8128046b5b0e&format=json&ts=1495055830238&sort=relevancy&q=\(term)%20site_type%3Anews%20%20language%3Aenglish"
        let urlNumCount = "https://webhose.io/filterWebContent?token=fc746d99-b259-4b82-925e-8128046b5b0e&format=json&ts=1492625498800&sort=crawled&q=\(term)%C2%A0%20language%3Aenglish%20site_type%3Anews"
        getNumberOfPosts(urlToRequest: urlShort, term: term, maxCall: false)
        getNumberOfPosts(urlToRequest: urlNumCount, term: term, maxCall: true)
    }
    
    
    //Get Count from JSON
    
    // Send in a url and the searchterm used in the url
    // Will add the amount of articles to the 'numsDict' using the key 'term'
    func getNumberOfPosts(urlToRequest: String, term: String, maxCall: Bool){
        //        let url4 = URL(string: urlToRequest)!
        //        let session4 = URLSession.shared
        //        let request = NSMutableURLRequest(url: url4)
        //        request.httpMethod = "GET"
        //        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        //        let paramString = ""
        //        request.httpBody = paramString.data(using: String.Encoding.utf8)
        //        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
        //            guard let _: Data = data, let _: URLResponse = response, error == nil else {
        //                print("*****error")
        //                return
        //            }
        //            //There is lots of bad variable names here, sorry
        //            //Starting with the full string(dataString) convert to utf8
        //            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        //            //get the index of that string + 16
        //            //print(dataString!)
        //            if((dataString?.length)! < 50){
        //                let error = true
        //                print("error")
        //                return
        //            }
        //            let totalResultsIndex = (dataString?.range(of: "\"totalResults\": ", options: String.CompareOptions.backwards).location)! + 16
        //            //get the substring from that index to the end of the string (Chops the first ~8000 chars or whatever)
        //            let newString = dataString?.substring(from: totalResultsIndex)
        //            //makes a new index for the first comma in the string
        //            let range: Range<String.Index> = newString!.range(of: ",")!
        //            //sets up another index or something
        //            let index: Int = newString!.distance(from: newString!.startIndex, to: range.lowerBound)
        //            //cuts everything off from the comma to the end leaving you with a string that is the number and add to dict
        //            if maxCall{
        //                self.numsDict[term+"Max"] = Int((newString?.substring(to: index))!)
        //            }else{
        //                self.numsDict[term] = Int((newString?.substring(to: index))!)
        //            }
        //           print(self.numsDict)
        //
        //            if maxCall && error != nil{
        //                DispatchQueue.main.async {
        //                    self.callsOnWatson(urlInput: term)
        ////                    self.updateProgressBar(withRatio: Float(self.numsDict[self.symbol]!/self.numsDict[self.symbol+"Max"]!))
        //                }
        //            }
        //
        //            //RANDOM NUM
        //
        //        }
        if(maxCall){
            self.callsOnWatson(urlInput: term)
            self.updateProgressBar(withRatio: Float(arc4random()) / Float(UINT32_MAX))
        }
        //        task.resume()
    }
    
    func callsOnWatson(urlInput: String){
        let urlShort = "https://webhose.io/filterWebContent?token=fc746d99-b259-4b82-925e-8128046b5b0e&format=json&ts=1495055830238&sort=relevancy&q=\(urlInput)%20site_type%3Anews%20%20language%3Aenglish"
        
        // Natural Lanaguage Understanding
        let username = "618ab670-193e-45ba-a9ec-66207f099279"
        let password = "1H6GGufcnMKM"
        let version = "2017-05-18"
        
        let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(username: username, password: password, version: version)
        
        let features = Features(concepts: ConceptsOptions(limit: 5), sentiment:SentimentOptions(document: true, targets: [self.symbol]))
        let parameters = Parameters(features: features, url: urlShort)
        
        let failure = { (error: Error) in print(error) }
        naturalLanguageUnderstanding.analyzeContent(withParameters: parameters, failure: failure) {
            results in
            
            DispatchQueue.main.async {
                print(results)
                //UPDATE ME
                let random  = Float(arc4random()) / Float(UINT32_MAX)
                if(random > 0.5){
                    self.leftView.backgroundColor = UIColor(red:0.82, green:0.33, blue:0.33, alpha:1.0)
                } else{
                    self.leftView.backgroundColor = UIColor(red:0.33, green:0.76, blue:0.37, alpha:1.0)
                }
            }
        }
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}





