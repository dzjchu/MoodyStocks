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

    var numsDict : Dictionary<String, Int> = Dictionary()
    
    //Loop from display
    let urlInput = "UAL"
    
    @IBOutlet weak var progressBar: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlShort = "https://webhose.io/filterWebContent?token=fc746d99-b259-4b82-925e-8128046b5b0e&format=json&ts=1495055830238&sort=relevancy&q=\(urlInput)%20site_type%3Anews%20%20language%3Aenglish"
        let urlNumCount = "https://webhose.io/filterWebContent?token=fc746d99-b259-4b82-925e-8128046b5b0e&format=json&ts=1492625498800&sort=crawled&q=\(urlInput)%C2%A0%20language%3Aenglish%20site_type%3Anews"
        
        
        // Natural Lanaguage Understanding
        let username = "618ab670-193e-45ba-a9ec-66207f099279"
        let password = "1H6GGufcnMKM"
        let version = "2017-05-18"
        
        let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(username: username, password: password, version: version)
        
        let urlToAnalyze = urlShort
        
        //Get Count from JSON
        
        // Send in a url and the searchterm used in the url
        // Will add the amount of articles to the 'numsDict' using the key 'term'
        // This runs async, so we will need to refesh every couple of seconds for new items
        getNumberOfNewsCounts(url1: urlShort, url2: urlNumCount, term: urlInput)
        
        let features = Features(concepts: ConceptsOptions(limit: 5), sentiment:SentimentOptions(document: true, targets: ["UAL"]))
        let parameters = Parameters(features: features, url: urlToAnalyze)
        
        let failure = { (error: Error) in print(error) }
        naturalLanguageUnderstanding.analyzeContent(withParameters: parameters, failure: failure) {
            results in
            print (results)
        }
        
    }
    
    func getNumberOfNewsCounts(url1: String, url2: String, term: String){
        getNumberOfPosts(urlToRequest: url1, term: urlInput, maxCall: false)
        getNumberOfPosts(urlToRequest: url2, term: urlInput+"Max", maxCall: true)
        
    }
    
    func getNumberOfPosts(urlToRequest: String, term: String, maxCall: Bool){
        
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString = ""
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            //There is lots of bad variable names here, sorry
            //Starting with the full string(dataString) convert to utf8
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //get the index of that string + 16
            let totalResultsIndex = (dataString?.range(of: "\"totalResults\": ", options: String.CompareOptions.backwards).location)! + 16
            //get the substring from that index to the end of the string (Chops the first ~8000 chars or whatever)
            let newString = dataString?.substring(from: totalResultsIndex)
            //makes a new index for the first comma in the string
            let range: Range<String.Index> = newString!.range(of: ",")!
            //sets up another index or something
            let index: Int = newString!.distance(from: newString!.startIndex, to: range.lowerBound)
            //cuts everything off from the comma to the end leaving you with a string that is the number and add to dict
            self.numsDict[term] = Int((newString?.substring(to: index))!)
            
            print(self.numsDict)
            
            if maxCall{
            DispatchQueue.main.async {
                    self.updateProgressBar()
                }
            }


        }
        task.resume()
    }
    
    func updateProgressBar(){
        
        let ratio = Float(Double(numsDict["UAL"]!)/Double(numsDict["UALMax"]!))
        print (ratio)
        if ratio < 0.25{
            progressBar.setProgress(ratio+0.5, animated: true)
        }else {
            progressBar.setProgress(ratio, animated: true)
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}




//Fancy subString stuff
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



