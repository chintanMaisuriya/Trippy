//
//  ForgotPasswordRequest.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 04/10/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import Foundation


struct ForgotPasswordRequest: Encodable
{
    var email      : String

    
    internal init(email: String = "")
    {
        self.email      = email
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
