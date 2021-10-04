//
//  Defaults.swift
//  MyTripMVVM
//
//  Created by Chintan Maisuriya on 10/10/20.
//  Copyright © 2020 Chintan Maisuriya. All rights reserved.
//


import Foundation

struct Default
{
    static let isAppLaunchedOnce    = "ISAPPLAUNCHEDONCE"
    static let isLoggedIn           = "ISLOGGEDIN"
    static let user                 = "USER"
}


class Defaults: NSObject
{
    
    static let shared = Defaults()
    
    private let groupDefaults = UserDefaults.standard
    
    // MARK: - Check Default
    
    internal func isContains(objectKey: String) -> Bool
    {
        return (groupDefaults.object(forKey: objectKey) != nil)
    }
    
    // MARK: - Remove Default
    internal func removeDefaults(_ forKey: String) {
        groupDefaults.removeObject(forKey: forKey)
        groupDefaults.synchronize()
    }
    
    // MARK: - Defaults String Values
    internal func getString(forKey key: String) -> String {
        var string: String?
        string = groupDefaults.string(forKey: key)
        return string ?? ""
    }
    
    internal func setString(_ strValue: String, forKey strKey: String) {
        groupDefaults.setValue(strValue, forKey: strKey)
        groupDefaults.synchronize()
    }
    
    // MARK: - Defaults Int Values
    internal func setInt(_ intValue: Int, forKey intKey: String) {
        groupDefaults.set(intValue, forKey: intKey)
        groupDefaults.synchronize()
    }
    
    internal func getInt(forKey key: String) -> Int {
        var integer: Int = 0
        integer = groupDefaults.integer(forKey: key)
        return integer
    }
    
    internal func getInt(forKey key: String) -> Int? {
        return groupDefaults.integer(forKey: key)
    }
    
    
    // MARK: - Defaults Double Values
    internal func setDouble(_ doubleValue: Double, forKey doubleKey: String) {
        groupDefaults.set(doubleValue, forKey: doubleKey)
        groupDefaults.synchronize()
    }
    
    internal func getDouble(forKey key: String) -> Double {
        var double: Double = 0.00
        double = groupDefaults.double(forKey: key)
        return double
    }
    
    // MARK: - Defaults Boolean Values
    internal func setBool(_ boolValue: Bool, forKey boolKey: String) {
        groupDefaults.set(boolValue, forKey: boolKey)
        groupDefaults.synchronize()
    }
    
    internal func getBool(forKey key: String) -> Bool {
        var bool: Bool = false
        bool = groupDefaults.bool(forKey: key)
        return bool
    }
    
    
    // MARK: - Defualts User Values
    internal func setCurrentUser(_ object: Usert, forKey strKey: String)
    {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            groupDefaults.set(encoded, forKey: strKey)
            groupDefaults.synchronize()
        }
    }
    
    internal func getCurrentUser(forKey key: String) -> Usert?
    {
        let decoder = JSONDecoder()
        
        if let data = groupDefaults.data(forKey: key),
           let user = try? decoder.decode(Usert.self, from: data)
        {
            return user
        }
        
        return nil
    }
    
    internal func updateDefaultUser(_ object: Usert)
    {
        if var userInfo = Defaults.shared.getCurrentUser(forKey: Default.user)
        {
            userInfo.name       = object.name
            userInfo.imageURL   = object.imageURL
            
            Defaults.shared.setCurrentUser(userInfo, forKey: Default.user)
        }
    }
}
