//
//  Utils.swift
//  Cricket Line
//
//  Created by TBI-iOS-02 on 23/03/20.
//  Copyright © 2020 TBI-iOS-02. All rights reserved.
//


import UIKit


class Utils: NSObject
{
    static var instance = Utils()
    
    
    class func getCurrentTime() -> String
    {
        let date        = Date()
        let calender    = Calendar.current
        let components  = calender.dateComponents([.hour,.minute,.second], from: date)
        var hour        = String()
        var minutes     = String()
        
        if components.hour! < 10
        {
            hour = String("0\(components.hour!)")
        }
        else
        {
            hour = String("\(components.hour!)")
        }
        
        if components.minute! < 10
        {
            minutes = String("0\(components.minute!)")
        }
        else
        {
            minutes = String("\(components.minute!)")
        }
        
        let currentTime = "\(hour):\(minutes)"
        return currentTime
    }
    
    class func getcurrentDate() -> String
    {
        let date        = Date()
        let calender    = Calendar.current
        let components  = calender.dateComponents([.day,.month,.year], from: date)
        var day         = String()
        var month       = String()
        
        if components.day! < 10
        {
            day = String("0\(components.day!)")
        }
        else
        {
            day = String("\(components.day!)")
        }
        
        if components.month! < 10
        {
            month = String("0\(components.month!)")
        }
        else
        {
            month = String("\(components.month!)")
        }
        
        let todayDate = "\(components.year!)/\(month)/\(day)"
        return todayDate
    }
    
    class func getTodaysDay() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayName: String = dateFormatter.string(from: Date())
        
        return dayName
    }
    
    class func getCurrentDateTimeInIST() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone   = NSTimeZone(abbreviation: "IST")! as TimeZone
        
        let date = NSDate()
        let cstTimeZoneStr = formatter.string(from: date as Date)
        
        return cstTimeZoneStr
    }
    
    
    class func getDateInLOCALFormat(_ strDate: String) -> String
    {
        var gmt = NSTimeZone(abbreviation: "IST")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = gmt! as TimeZone
        
        let date: Date? = dateFormatter.date(from: strDate)
        gmt = NSTimeZone.system as NSTimeZone
        dateFormatter.timeZone   = gmt! as TimeZone
        dateFormatter.dateFormat = "d MMM, yyyy"
        var timeStamp: String = dateFormatter.string(from: date!)
        
        if (timeStamp.count) <= 0 {
            timeStamp = ""
        }
        
        return timeStamp
    }
    
    class func getTimeInLOCALFormat(_ strDate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var gmt = NSTimeZone(abbreviation: "IST")
        dateFormatter.timeZone = gmt! as TimeZone
        
        let date: Date? = dateFormatter.date(from: strDate)
        gmt = NSTimeZone.system as NSTimeZone
        dateFormatter.timeZone   = gmt! as TimeZone
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol   = "am"
        dateFormatter.pmSymbol   = "pm"
        var timeStamp: String    = dateFormatter.string(from: date!)
        
        if (timeStamp.count) <= 0 {
            timeStamp = ""
        }
        
        return timeStamp
    }
    
    class func getDateTimeInLOCALFormat(_ strDate: String, fromFormat: String = "yyyy-MM-dd HH:mm:ss", toFormat: String = "dd MMM yyyy, hh:mm a") -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        
        var gmt = NSTimeZone(abbreviation: "PST")
        dateFormatter.timeZone = gmt! as TimeZone
        
        let date: Date? = dateFormatter.date(from: strDate)
        gmt = NSTimeZone.system as NSTimeZone
        dateFormatter.timeZone   = gmt! as TimeZone
        dateFormatter.dateFormat = toFormat
        dateFormatter.amSymbol   = "am"
        dateFormatter.pmSymbol   = "pm"
        var timeStamp: String    = dateFormatter.string(from: date!)
        
        if (timeStamp.count) <= 0 {
            timeStamp = ""
        }
        
        return timeStamp
    }
    
    
    class func getTimeIn24HrFormat(_ strDate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        
        var gmt = NSTimeZone(abbreviation: "IST")
        dateFormatter.timeZone = gmt! as TimeZone
        
        let date: Date? = dateFormatter.date(from: strDate)
        gmt = NSTimeZone.system as NSTimeZone
        dateFormatter.timeZone   = gmt! as TimeZone
        dateFormatter.dateFormat = "HH:mm:ss"
        var timeStamp: String    = dateFormatter.string(from: date!)
        
        if (timeStamp.count) <= 0 {
            timeStamp = ""
        }
        
        return timeStamp
    }
    
    
    class func getDatepicker(pickerMode: UIDatePicker.Mode) -> UIDatePicker?
    {
        var minDate: Date?
        
        if ((pickerMode == .date) || (pickerMode == .dateAndTime))
        {
            var minDateComponent    = Calendar.current.dateComponents([.day,.month,.year], from: Date())
            minDateComponent.day    = 01
            minDateComponent.month  = 01
            minDateComponent.year   = 1945
            
            minDate = Calendar.current.date(from: minDateComponent)
        }
                
        let datePicker  = UIDatePicker.init()
        datePicker.datePickerMode   = pickerMode
        datePicker.locale   = .current
        datePicker.minimumDate  = minDate
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        
        datePicker.setValue(UIColor(named: "Color_Text1") ?? UIColor.black, forKeyPath: "textColor")
        return datePicker
    }
    
    
    // --
    
    class func setSVprogress()
    {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultAnimationType(.native)
        //SVProgressHUD.setFadeInAnimationDuration(0.1)
        
        SVProgressHUD.setMinimumDismissTimeInterval(0.8)
        SVProgressHUD.setMaximumDismissTimeInterval(1.2)
    }
    
    
    class func showAlert(controller: UIViewController, title:String, message:String)
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let btnOK     = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertView.addAction(btnOK)
        controller.present(alertView, animated: true, completion: nil)
    }
    
    
    class func showToast(position: Drop.Position = .top, duration: TimeInterval = 3, title: String, subtitle: String? = nil, icon: UIImage? = nil, buttonIcon: UIImage? = nil)
    {
        let action: Drop.Action = .init(icon: buttonIcon, handler: {
            print("Drop tapped")
            Drops.hideCurrent()
        })
        
        let drop = Drop(title: title, subtitle: subtitle, icon: icon, action: action, position: position, duration: .seconds(duration))
        Drops.show(drop)
    }
    
    // --
    
    class func trimString(_ text: String) -> String
    {
        let trimmedString: String = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }
    
    class func validateEmail(_ string: String) -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest  = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: string)
    }
    
    class func validatePassword(_ string: String) -> Bool
    {
        let passwordRegex   = ".{6,}"
        let predicate       = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with: string)
    }
    
    class func validatePhoneNumber(_ string: String) -> Bool
    {
        let phoneNoRegex = "^(\\+?)(\\d{10})$"
        let phoneNoTest  = NSPredicate(format: "SELF MATCHES %@", phoneNoRegex)
        return phoneNoTest.evaluate(with: string)
    }
    
    class func validateDuration(_ string: String) -> Bool
    {
        let durationRegex = "[0-9]{2}:[0-9]{2}:[0-9]{2}"
        let durationTest  = NSPredicate(format: "SELF MATCHES %@", durationRegex)
        return durationTest.evaluate(with: string)
    }
    
    class func getAddressString(addressInfo: NSDictionary) -> String
    {
        var addressString     = ""
        let strAdd1           = addressInfo["address1"] as! String
        let strAdd2           = addressInfo["address2"] as! String
        let strAdd3           = addressInfo["address3"] as! String
        let strCity           = addressInfo["city"] as! String
        let strState          = addressInfo["state"] as! String
        let strPincode        = addressInfo["pincode"] as! String
        
        addressString         = "\(strAdd1), \(strAdd2), \(strAdd3), \(strCity), \(strState)-\(strPincode)"
        
        return addressString
    }
    
    // --
    
    
    class func setCustomFontSize(noramlSize: Int) -> CGFloat
    {
        
        //Current runable device/simulator width find
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        
        // basewidth you have set like your base storybord is IPhoneSE this storybord width 320px.
        let baseWidth: CGFloat = 320
        
        let fontSize = CGFloat(noramlSize) * (width / baseWidth)
        
        return fontSize.rounded()
    }
    
    class func findHeight(fromText text: String, maxWidth: CGFloat, font: UIFont) -> CGRect
    {
        let attributes = [NSAttributedString.Key.font: font]
        let rectAmnt: CGRect = text.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: (attributes as Any as! [NSAttributedString.Key : Any]), context: nil)
        return rectAmnt
    }
    
    
    //Convert the Swift dictionary to JSON String
    class func JSONString(object: Any)  -> String?
    {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            // here "decoded" is of type `Any`, decoded from JSON data
            return jsonString
            // you can now cast it with the right type
            
        } catch {
            print(error.localizedDescription)
        }
        
        return ""
    }

    
    //--
    
    class func congfigureButton(button: UIButton, font: UIFont? = nil, borderColor: UIColor? = .clear, borderWidth: CGFloat = 0, cornerRadius: CGFloat = 6)
    {
        button.layer.borderColor    = borderColor?.cgColor
        button.layer.borderWidth    = borderWidth
        button.layer.cornerRadius = cornerRadius
        button.layer.maskedCorners    = [.layerMinXMinYCorner , .layerMaxXMinYCorner ,.layerMaxXMaxYCorner ,.layerMinXMaxYCorner]
        button.clipsToBounds = true
        button.titleLabel?.font = font
    }
    
    class func congfigureRoundedButton(button: UIButton, borderColor: UIColor? = .clear, borderWidth: CGFloat = 0)
    {
        button.layer.borderColor    = borderColor?.cgColor
        button.layer.borderWidth    = borderWidth
        button.layer.cornerRadius   = button.frame.width / 2
        button.layer.maskedCorners  = [.layerMinXMinYCorner , .layerMaxXMinYCorner ,.layerMaxXMaxYCorner ,.layerMinXMaxYCorner]
        button.clipsToBounds = true
    }
    
    class func congfigureTextfield(textField: UITextField, textFieldDelegate: UITextFieldDelegate? = nil, tag: Int = 0, borderColor: UIColor? = .clear, borderWidth: CGFloat = 0, cornerRadius: CGFloat = 0.0, tintColor: UIColor? = .black)
    {
        if tag > 0 { textField.tag = tag }
        
        textField.layer.borderColor         = borderColor?.cgColor
        textField.layer.borderWidth         = borderWidth
        textField.layer.cornerRadius        = cornerRadius
        textField.clipsToBounds             = true
        textField.keyboardToolbar.tintColor = tintColor
        textField.delegate = textFieldDelegate
    }
}
