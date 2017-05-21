//
//  ViewController.swift
//  MoodyStocks
//
//  Created by Dan Chu on 5/18/17.
//  Copyright © 2017 AlphaChron. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
	var myStocks: [NSManagedObject] = []
    //Loop from display
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Stock",
                                       in: managedContext)!
        let newStock = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        newStock.setValue(symbol.uppercased(), forKeyPath: "symbol")
        
        do {
            try managedContext.save()
            myStocks.append(newStock)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myStocks.count
    }
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        	if editingStyle == .delete {
//                deleteStockIndexPath = indexPath
//            let stockToDelete = myStocks[indexPath.row]
//            print("\(stockToDelete)")
//            confirmDelete(stock: (stockToDelete.value(forKeyPath: "symbol") as? String)!)
//        }
//    }
//
//    func handleDeleteStock(alertAction: UIAlertAction!) -> Void {
//        if let indexPath = deleteStockIndexPath {
//            tableView.beginUpdates()
//            myStocks.remove(at: indexPath.row)
//            
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            deleteStockIndexPath = nil
//            
//            tableView.endUpdates()
//        }
//    }
//    
//    func confirmDelete(stock: String) {
//        let alert = UIAlertController(title: "Delete Stock", message: "Are you sure you want to permanently delete \(stock)?", preferredStyle: .actionSheet)
//        
//        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteStock)
//        
//        
//        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteStock)
//        
//        alert.addAction(DeleteAction)
//        alert.addAction(CancelAction)
//        
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    
//    func cancelDeleteStock(alertAction: UIAlertAction!) {
//        deleteStockIndexPath = nil
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stock = myStocks[indexPath.row]
//        urlInput = (stock.value(forKeyPath: "symbol") as? String)!
//        print (urlInput)
//        callsOnWatson(urlInput: stock.value(forKeyPath: "symbol") as! String)
//        print (stock)
//        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCell
        	cell.rightLabel?.text = stock.value(forKeyPath: "symbol") as? String
            cell.symbol = (cell.rightLabel.text)!
        	cell.leftView.backgroundColor = UIColor.green
        

        
            cell.getNumberOfNewsCounts(term: cell.symbol)
//        //pull out stuff
//        
//        let stockNum = stock.value(forKeyPath: "symbol") as? String
//        
//        if (numsDict[stockNum!] != nil && numsDict.count > 0){
//            let ratio = Float(Double(numsDict[stockNum!]!)/Double(numsDict[stockNum!]!))
//            print (ratio)
//            cell.updateProgressBar(withRatio: ratio)
//        } else {
//            print ("Error1")
//        }
//    
        return cell
    }
    
}








