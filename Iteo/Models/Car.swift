//
//  Car.swift
//  Iteo
//
//  Created by Piotr Mol on 29/05/2019.
//  Copyright © 2019 Piotr Mol. All rights reserved.
//

import Foundation

struct Car: Codable {
    let id: String?
    let brand: String?
    let model: String?
    let name: String?
    let year: String?
    
    private enum CodingKeys : String, CodingKey {
        case id = "_id"
        case brand
        case model
        case name
        case year
    }
}
