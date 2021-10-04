//
//  Network.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 23/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import Foundation
import Reachability


class NetworkManager: NSObject
{
    //MARK: -
    var updateConnectionStatus: ((Bool)->())?

    //MARK: -

    
    static let shared : NetworkManager = { return NetworkManager() }()
    
    fileprivate var reachability: Reachability?
    public var isReachable = false { didSet { updateConnectionStatus?(isReachable) } }
        
    
    //MARK: -
    
    override init()
    {
        super.init()
        checkConnection()
    }
}


// MARK:- Setup Reachability

extension NetworkManager
{
    public func checkConnection()
    {
        stopNotifier()
        setupReachability()
        startNotifier()
    }
    
    
    private func setupReachability()
    {        
        do {
            reachability = try Reachability(hostname: "www.google.com")
            reachability?.whenReachable = {[weak self] reachability in
                self?.isReachable = true
            }
            reachability?.whenUnreachable = {[weak self] reachability in
                self?.isReachable = false
            }
        } catch {}
    }
}


// MARK:- Start and stop Notifier

extension NetworkManager
{
    private func startNotifier()
    {
        do {
            try reachability?.startNotifier()
        } catch {
            print( "Unable to start\nnotifier")
            return
        }
    }
    
    private func stopNotifier()
    {
        reachability?.stopNotifier()
    }
}
