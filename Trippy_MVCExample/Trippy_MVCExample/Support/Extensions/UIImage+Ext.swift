//
//  UIImage+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit


extension UIImage
{
    
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    
    func getImageRatio() -> CGFloat
    {
        let imageRatio = CGFloat(self.size.width / self.size.height)
        return imageRatio
    }
    
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage
    {
        let scale    = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize  = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    
    
    //Summon this function VVV
    func resizeImageWithAspect(scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage
    {
        let oldWidth    = self.size.width
        let oldHeight   = self.size.height
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight
        
        let newHeight = oldHeight * scaleFactor
        let newWidth  = oldWidth * scaleFactor
        let newSize   = CGSize(width: newWidth, height: newHeight)
        
        return imageWithSize(image: self, size: newSize);
    }
    
    private func imageWithSize(image: UIImage,size: CGSize)->UIImage
    {
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale))
        {
            UIGraphicsBeginImageContextWithOptions(size,false,UIScreen.main.scale);
        }
        else
        {
            UIGraphicsBeginImageContext(size);
        }
        
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
    
    // image with rounded corners
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage?
    {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        
        if let radius = radius, radius > 0 && radius <= maxRadius
        {
            cornerRadius = radius
        }
        else
        {
            cornerRadius = maxRadius
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    class func colorForNavBar(color: UIColor) -> UIImage
    {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        //    Or if you need a thinner border :
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
