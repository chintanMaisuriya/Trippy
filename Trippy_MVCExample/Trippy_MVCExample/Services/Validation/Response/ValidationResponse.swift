//
//  ValidationResponse.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 03/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//


import Foundation

struct ValidationResponse {
    let error   : ValidationError?
    let message : String?
    let isValid : Bool
}
