//
//  UIColor+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit


extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        assert(red   >= 0 && red   <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue  >= 0 && blue  <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int)
    {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    /*
     convenience init(hex:Int, alpha:CGFloat = 1.0)
     {
     self.init(
     red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
     green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
     blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
     alpha: alpha
     )
     }
     */
    
    // hex sample: 0xf43737
    convenience init(_ hex: Int, alpha: Double = 1.0)
    {
        self.init(red: CGFloat((hex >> 16) & 0xFF) / 255.0, green: CGFloat((hex >> 8) & 0xFF) / 255.0, blue: CGFloat((hex) & 0xFF) / 255.0, alpha: CGFloat(255 * alpha) / 255)
    }

    convenience init(_ hexString: String, alpha: Double = 1.0)
    {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }

        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(255 * alpha) / 255)
    }

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1)
    {
        self.init(red: (r / 255), green: (g / 255), blue: (b / 255), alpha: a)
    }
    
    
    static func random() -> UIColor
    {
        return UIColor(red:   .randomFloatNumb(),
                       green: .randomFloatNumb(),
                       blue:  .randomFloatNumb(),
                       alpha: 1.0)
    }
    
    func gradientColorFrom(color color1: UIColor, toColor color2: UIColor ,withSize size: CGSize) ->UIColor
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        
        let context     = UIGraphicsGetCurrentContext();
        let colorspace  = CGColorSpaceCreateDeviceRGB();
        let colors      = [color1.cgColor, color2.cgColor] as CFArray;
        let gradient    = CGGradient(colorsSpace: colorspace, colors: colors, locations: nil);
        
        context!.drawLinearGradient(gradient!, start: CGPoint(x:0, y:0), end: CGPoint(x:size.width, y:0), options: CGGradientDrawingOptions(rawValue: UInt32(0)));
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        let finalCColor = UIColor(patternImage: image!);
        return finalCColor;
    }
    
}
