//
//  CarDetailsViewController.swift
//  Iteo
//
//  Created by Piotr Mol on 29/05/2019.
//  Copyright © 2019 Piotr Mol. All rights reserved.
//

import UIKit

class CarDetailsTableViewController: UITableViewController {
  
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var car: Car?
    private var isLabelSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Car detail"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isLabelSet {
            modelLabel.text = car?.model ?? "---"
            brandLabel.text = car?.brand ?? "---"
            yearLabel.text = car?.year ?? "---"
            nameLabel.text = car?.name ?? "---"
            
            isLabelSet = true
        }
    }
}
