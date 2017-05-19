//
//  CustomCell.swift
//  MoodyStocks
//
//  Created by Istvan on 5/19/17.
//  Copyright © 2017 AlphaChron. All rights reserved.
//

import UIKit



class CustomCell: UITableViewCell {
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    func updateProgressBar(withRatio: Float){
        if withRatio < 0.25{
            progressBar.setProgress(withRatio + 0.5, animated: true)
        }else {
            progressBar.setProgress(withRatio, animated: true)
        }
    }


}




