//
//  Application.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 25/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import UIKit

public struct Application
{
    static let displayName  = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
    static let version      = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let build        = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String
    static let bundleID     = Bundle.main.bundleIdentifier! as String
    static let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

    public static var deviceVersion: String {
        var size: Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }
}
