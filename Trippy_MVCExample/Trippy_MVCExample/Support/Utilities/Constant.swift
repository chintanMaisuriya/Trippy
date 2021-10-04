//
//  Constant.swift
//  Cricket Line
//
//  Created by TBI-iOS-02 on 23/03/20.
//  Copyright © 2020 TBI-iOS-02. All rights reserved.
//

import UIKit
import AVFoundation


class Constant: NSObject
{
    
    static let SCREEN_WIDTH  = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    //Mark:
    static let backgoundColor   : UIColor   = UIColor.white
    static let theme_color      : UIColor   = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.0862745098, alpha: 1) //UIColor(red: 248.0/255.0, green: 160.0/255.0, blue: 10.0/255.0, alpha: 1.0)
    
    static let logo_White       : UIImage   = UIImage(named: "mtAdd")!
    static let logo_Colored     : UIImage   = UIImage(named: "mtAdd")!

    
    //===============================================================================================================================================
    
    static let APPLICATION_IDENTIFIER           = "ApplicationIdentifier"
    static let IS_USER_LOGGEDIN_ON_FRESHINSTALL = "isAppAlreadyLaunchedOnce"


    
    //Validation Message
    static let enterInvalidValue            = "You've entered an invalid value"
    
    static let enterFullName                = "Please enter your full name"
    static let enterEmail                   = "Please enter email address"
    static let enterValidEmail              = "Please enter valid email address"
    static let enterPassword                = "Please enter password"
    static let enterValidPassword           = "Please enter valid password"
    static let enterConfirmPassword         = "Please enter confirm password"
    static let enterValidConfirmPassword    = "Please enter valid confirm password"
    static let enterCorrectPassword         = "Your confirm password should match your new password"

    static let enterTitle                   = "Please enter trip title"
    static let selectDate                   = "Please select your trip date"
    static let selectPhoto                  = "Please select atleast one trip photo"
    
    static let noInternet                   = "Please check your internet Connectivity"
    static let chooseSource                 = "Please select an image source"
    static let noCamera                     = "No camera detected on device"
    static let lostConnection               = "Connection lost"
    
    
    static let placeholderUnableToGetData       = "⚠️\nUnable to get data."
    static let placeholderUnableToGetLocation   = "⚠️\nUnable to get your location."
    static let placeholderNoTrip                = "⚠️\n\nNo trip(s) found! You can add the trip by clicking + button above."
    static let placeholderLoadingData           = "⏳\nOne Moment Please..."
    
}


struct ScreenSize
{
    static let size         = UIScreen.main.bounds.size
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}
