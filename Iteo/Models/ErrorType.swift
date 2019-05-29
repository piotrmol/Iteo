//
//  ErrorTypes.swift
//  Iteo
//
//  Created by Piotr Mol on 29/05/2019.
//  Copyright © 2019 Piotr Mol. All rights reserved.
//

import Foundation

enum ErrorType {
    case serverIssue , badJson, noDataRecived, emptyField, internalError
    
    var description: (String, String) {
        switch self {
        case .serverIssue:
            return ("Cannot connect to remote server", "Close")
        case .badJson:
            return ("Invalid data recived from remote server", "Close")
        case .noDataRecived:
            return ("No data recived from remote server", "Close")
        case .emptyField:
            return ("Please, fill all fields before sending", "Close")
        case .internalError:
            return ("Internal app error", "Close")
        }
    }
}
