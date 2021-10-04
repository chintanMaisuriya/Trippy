//
//  UITextView+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit


extension UITextView
{
    func numberOfCharactersThatFitTextView() -> Int
    {
        //let visRect = self.convert(self.bounds, to: self.subviews.)
        
        let layoutManager = self.layoutManager
        let container = self.textContainer
        
        let glyphRange = layoutManager.glyphRange(forBoundingRect: self.bounds, in: container)
        let charRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        return Int(charRange.length)
        
        /*
         let fontRef = CTFontCreateWithName(font!.fontName as CFString, font!.pointSize, nil)
         let attributes = [kCTFontAttributeName : fontRef]
         let attributedString = NSAttributedString(string: text!, attributes: attributes as [NSAttributedString.Key : Any])
         let frameSetterRef = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
         
         var characterFitRange: CFRange = CFRange()
         
         CTFramesetterSuggestFrameSizeWithConstraints(frameSetterRef, CFRangeMake(0, 0), nil, CGSize(width: bounds.size.width, height: bounds.size.height), &characterFitRange)
         return Int(characterFitRange.length)
         
         */
        
    }
    
    func visibleRangeOfTextView() -> NSRange
    {
        let bounds = self.bounds
        let origin = CGPoint(x: 10, y: 10)
        guard let startCharacterRange = self.characterRange(at: origin) else {
            return NSRange(location: 0, length: 0)
        }
        
        let startPosition = startCharacterRange.start
        let endPoint = CGPoint(x: bounds.maxX,
                               y: bounds.maxY)
        guard let endCharacterRange = self.characterRange(at: endPoint) else {
            return NSRange(location: 0, length: 0)
        }
        
        let endPosition = endCharacterRange.end
        
        let startIndex = self.offset(from: self.beginningOfDocument, to: startPosition)
        let endIndex = self.offset(from: startPosition, to: endPosition)
        return NSRange(location: startIndex, length: endIndex)
    }
    
    /// Modifies the top content inset to center the text vertically.
    ///
    /// Use KVO on the UITextView contentSize and call this method inside observeValue(forKeyPath:of:change:context:)
    func alignTextVerticallyInContainer()
    {
        
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
        
        
        /*
         var topCorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
         topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
         self.contentInset.top = topCorrect
         */
    }
}
