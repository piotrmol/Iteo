//
//  ViewController.swift
//  Iteo
//
//  Created by Piotr Mol on 29/05/2019.
//  Copyright © 2019 Piotr Mol. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController, CarAddedDelegate {
    var cars = [Car]()
    private let carService = CarService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cars"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        getCars()
    }
    

    private func getCars() {
        carService.getCars() { error , cars in
            DispatchQueue.main.async { [weak self] in
                if let e = error {
                    self?.showErrorAlert(with: e.description.0 ,buttonText: e.description.1)
                }
                
                if let cars = cars {
                    self?.cars = cars
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCarSegue" {
            if let addCarTableViewController = segue.destination as? AddCarTableViewController {
                addCarTableViewController.delegate = self
            }
        } else if segue.identifier == "showDetailsSegue" {
            if let carDetailsTableViewController = segue.destination as? CarDetailsTableViewController, let index = tableView.indexPathForSelectedRow {
                carDetailsTableViewController.car = cars[index.row]
            }
        }
    }
    
    func add(car: Car) {
        self.cars.insert(car, at: 0)
        self.tableView.reloadData()
    }
}

//MARK: - Table view delegates and datasource methods

extension CarsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carCell", for: indexPath)
    
        cell.textLabel?.text = cars[indexPath.row].name
        cell.textLabel?.numberOfLines = 0
        
        cell.detailTextLabel?.text = cars[indexPath.row].model
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetailsSegue", sender: self)
    }
    
}

