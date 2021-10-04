//
//  ChangePasswordRequest.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 30/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import Foundation


struct ChangePasswordRequest: Encodable
{
    var newPassword     : String
    var confirmPassword : String

    
    internal init(newPassword: String = "", confirmPassword: String = "")
    {
        self.newPassword        = newPassword
        self.confirmPassword    = confirmPassword
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
