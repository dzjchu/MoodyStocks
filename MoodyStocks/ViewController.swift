//
//  ViewController.swift
//  MoodyStocks
//
//  Created by Dan Chu on 5/18/17.
//  Copyright © 2017 AlphaChron. All rights reserved.
//

import UIKit
import CoreData
import NaturalLanguageUnderstandingV1

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
	var myStocks: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Moody Stocks"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Natural Lanaguage Understanding
        let username = "618ab670-193e-45ba-a9ec-66207f099279"
        let password = "1H6GGufcnMKM"
        let version = "2017-05-18"
        
        let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(username: username, password: password, version: version)
        
        let urlToAnalyze = "http://webhose.io/filterWebContent?token=fc746d99-b259-4b82-925e-8128046b5b0e&format=json&ts=1495055830238&sort=relevancy&q=UAL%20site_type%3Anews%20%20language%3Aenglish"
        
        let features = Features(concepts: ConceptsOptions(limit: 5), sentiment:SentimentOptions(document: true, targets: ["UAL"]))
        let parameters = Parameters(features: features, url: urlToAnalyze)
        
        let failure = { (error: Error) in print(error) }
        naturalLanguageUnderstanding.analyzeContent(withParameters: parameters, failure: failure) {
            results in 
            print (results)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Stock")
        
        do {
            myStocks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Stock",
                                      message: "Add a new stock",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                let symbolToSave = textField.text else {
                    return
            	}
            self.save(symbol: symbolToSave)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(symbol: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Stock",
                                       in: managedContext)!
        let newStock = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        // 3
        newStock.setValue(symbol, forKeyPath: "symbol")
        // 4
        do {
            try managedContext.save()
            myStocks.append(newStock)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let stock = myStocks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = stock.value(forKeyPath: "symbol") as? String
        return cell
    }
    
}












