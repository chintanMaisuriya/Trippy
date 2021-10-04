//
//  LoginRequest.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 23/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import Foundation

struct LoginRequest: Encodable
{
    var email      : String
    var password   : String

    
    internal init(email: String = "", password: String = "")
    {
        self.email      = email
        self.password   = password
    }
    
    
    var asDictionary : [String : Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }
}
