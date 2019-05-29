//
//  AddCarViewController.swift
//  Iteo
//
//  Created by Piotr Mol on 29/05/2019.
//  Copyright © 2019 Piotr Mol. All rights reserved.
//

import UIKit

class AddCarTableViewController: UITableViewController {
    
    @IBOutlet weak var saveCarButton: UIButton!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
   
    
    private var name: String?
    private var year: String?
    private var brand: String?
    private var model: String?
    private var carService = CarService.shared
    weak var delegate: CarAddedDelegate?

    @IBAction func saveCar(_ sender: UIButton) {
        if checkIfFormIsValid() {
            addCar()
        } else {
            showErrorAlert(with: ErrorType.emptyField.description.0 ,buttonText: ErrorType.emptyField.description.1)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add car"
        
        prepareTextFieldsForUse()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhenUserTapAround))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func addCar() {
        if let name = self.name, let year = self.year, let brand = self.brand, let model = self.model {
            carService.save(car: Car(id: nil, brand: brand, model: model, name: name, year: year)) {  error, car in
                DispatchQueue.main.async { [weak self] in
                    if let error = error {
                        self?.showErrorAlert(with: error.description.0 ,buttonText: error.description.1)
                    } else if let car = car {
                        self?.delegate?.add(car: car)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    private func prepareTextFieldsForUse(){
        modelTextField.addTarget(self, action: #selector(textChanged(in:)), for: .editingChanged)
        brandTextField.addTarget(self, action: #selector(textChanged(in:)), for: .editingChanged)
        yearTextField.addTarget(self, action: #selector(textChanged(in:)), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(textChanged(in:)), for: .editingChanged)
        
        modelTextField.delegate = self
        brandTextField.delegate = self
        yearTextField.delegate = self
        nameTextField.delegate = self
    }
    
    private func checkIfFormIsValid()-> Bool {
        var isValid = true
        
        if name == nil || year == nil || brand == nil || model == nil {
            isValid = false
        }
        
        return isValid
    }
    
    @objc private func textChanged(in textField: UITextField) {
        if textField.isEqual(modelTextField) {
            model = textField.text
        } else if textField.isEqual(brandTextField) {
            brand = textField.text
        } else if textField.isEqual(yearTextField) {
            year = textField.text
        } else {
            name = textField.text
        }
    }
    
    @objc private func dismissKeyboardWhenUserTapAround() {
        view.endEditing(true)
    }

}

//MARK:- Text fields delegate methods
extension AddCarTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
