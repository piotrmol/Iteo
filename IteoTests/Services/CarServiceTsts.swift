//
//  CarServiceTsts.swift
//  IteoTests
//
//  Created by Piotr Mol on 29/05/2019.
//  Copyright © 2019 Piotr Mol. All rights reserved.
//

import XCTest
@testable import Iteo

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> ()

    init(closure: @escaping () -> ()) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}

class URLSessionUploadTaskMock: URLSessionUploadTask {
    private let closure: () -> ()
    
    init(closure: @escaping () -> ()) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    var data: Data?
    var error: Error?
    var car: Car?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
    
    override func uploadTask(with: URLRequest, from: Data?, completionHandler: @escaping CompletionHandler) -> URLSessionUploadTask {
        let data = self.data
        let error = self.error
        return URLSessionUploadTaskMock {
            completionHandler(data, nil, error)
        }
    }

}



class CarServiceTsts: XCTestCase {
    let getResponse = " [{ \"_id\": \"5ceeb45d6f8bd6170000034a\", \"name\": \"best car \", \"model\": \"g20\", \"brand\": \"bmw\", \"year\": \"2019\" }]"
    let postResponse = "{ \"_id\": \"5ceeb45d6f8bd6170000034a\", \"name\": \"best car \", \"model\": \"g20\", \"brand\": \"bmw\", \"year\": \"2019\" }"
    let invalidResponse = "test"
    
    func testGetCars(){
        let session = URLSessionMock()
        session.data = nil
        session.error = NSError(domain: "Test error", code: 404, userInfo: nil)

        let carService = CarService(session: session)

        
        var responseError: ErrorType?
        var responseCars: [Car]?
        
        carService.getCars() { error , cars  in
            responseError = error
            responseCars = cars
        }
        
        XCTAssertEqual(responseError, ErrorType.serverIssue)
        XCTAssertNil(responseCars)
        
        session.data = invalidResponse.data(using: .utf8)
        session.error = nil
        
        carService.getCars() { error , cars  in
            responseError = error
            responseCars = cars
        }
        
        XCTAssertEqual(responseError, ErrorType.badJson)
        XCTAssertNil(responseCars)
        
        session.data = getResponse.data(using: .utf8)
        session.error = nil
        
        carService.getCars() { error , cars  in
            responseError = error
            responseCars = cars
        }
        
        XCTAssertEqual(responseCars?.count, 1)
        XCTAssertNotNil(responseCars?[0].name)
        XCTAssertNotNil(responseCars?[0].model)
        XCTAssertNotNil(responseCars?[0].brand)
        XCTAssertNotNil(responseCars?[0].year)
        XCTAssertNil(responseError)

    }
    

    func testSaveCar() {
        let session = URLSessionMock()
        session.data = postResponse.data(using: .utf8)
        session.error = nil
        
        let carService = CarService(session: session)
        let car = Car(id: nil, brand: "test", model: "test", name: "test", year: "test")
        
        var responseError: ErrorType?
        var responseCar: Car?
        
        carService.save(car: car) { error, car in
            responseCar = car
            responseError = error
        }
        
        XCTAssertNotNil(responseCar)
        XCTAssertNil(responseError)
        
        session.data = invalidResponse.data(using: .utf8)
        session.error = nil
        
        carService.save(car: car) { error, car in
            responseCar = car
            responseError = error
        }
        
        XCTAssertNotNil(responseError)
        XCTAssertNil(responseCar)
        XCTAssertEqual(responseError, ErrorType.badJson)
        
        session.data = nil
        session.error = NSError(domain: "Test error", code: 404, userInfo: nil)
        
        carService.save(car: car) { error, car in
            responseCar = car
            responseError = error
        }

        XCTAssertNotNil(responseError)
        XCTAssertNil(responseCar)
        XCTAssertEqual(responseError, ErrorType.serverIssue)
    }
}
