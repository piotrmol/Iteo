//
//  CarService.swift
//  Iteo
//
//  Created by Piotr Mol on 29/05/2019.
//  Copyright © 2019 Piotr Mol. All rights reserved.
//

import Foundation

class CarService {
    static let shared = CarService()
    
    private let session: URLSession
    private let baseUrl = "https://iteotest-bb88.restdb.io/rest/cars"
    private let headers = [
        "Content-Type": "application/json",
        "Accept" : "application/json",
        "x-apikey" : "5bb889c2bd79880aab0a79f5"
    ]
    private enum RequestMethod: String {
        case post = "POST", get = "GET"
    }
    
    init(session: URLSession = .shared ){
        self.session = session
    }
    
    //MARK:- API methods
    
    func getCars(completition: @escaping(_ errorDescription: ErrorType?, _ cars: [Car]?) -> ()) {
        guard let url = URL(string: baseUrl) else {
            completition(ErrorType.internalError, nil)
            return
        }
        
        let request = prepareRequest(for: .get, with: url)
        
        let task = session.dataTask(with: request) { [unowned self] data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completition(ErrorType.serverIssue, nil)
                return
            }
            
            guard let data = data else {
                completition(ErrorType.noDataRecived, nil)
                return
            }
            let parsedCars = self.decode(cars: data)
            completition(parsedCars.0, parsedCars.1)
            
        }
        
        task.resume()
    }
    
    func save(car: Car, completition: @escaping(_ errorDescription: ErrorType?, _ cars: Car?) -> ()){
        guard let url = URL(string: baseUrl) else {
            print("Bad url")
            completition(ErrorType.serverIssue, nil)
            return
        }
        
        let request = prepareRequest(for: .post, with: url)
        guard let data = encode(car: car) else {
            print("Cannot encode json")
            completition(ErrorType.internalError, nil)
            return
        }
        
        let task = session.uploadTask(with: request, from: data) { [unowned self] responseData, respone, error in
            if let error = error {
                print(error.localizedDescription)
                completition(ErrorType.serverIssue, nil)
            }
            
            guard let responseData = responseData else {
                return
            }
            let newCar = self.decode(car: responseData)
            completition(newCar.0, newCar.1)
        }
        
        task.resume()
    }
    
    //MARK:- helpers methods
    
    private func prepareRequest(for method: RequestMethod, with url: URL)-> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers.keys.forEach { key in
            request.setValue(headers[key], forHTTPHeaderField: key)
        }
        return request
    }
    
    private func decode(cars data: Data)-> (ErrorType?, [Car]?) {
        do {
            let decoder = JSONDecoder()
            let cars = try decoder.decode([Car].self, from: data)
            return(nil, cars)
        } catch {
            print(error.localizedDescription)
            return(ErrorType.badJson, nil)
        }
    }
    
    private func decode(car data: Data) -> (ErrorType?, Car?) {
        do {
            let decoder = JSONDecoder()
            let cars = try decoder.decode(Car.self, from: data)
            return(nil, cars)
        } catch {
            print(error.localizedDescription)
            return(ErrorType.badJson, nil)
        }
    }
    
    private func encode(car: Car)-> Data? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(car)
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}


