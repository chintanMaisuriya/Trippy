//
//  UIImageView+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 04/10/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func downloadImage(url:String?, placeholderImage: String = "") {
        
        guard let strURL = url else {
            self.image = UIImage(named: placeholderImage)
            return
        }
        
        let stringWithoutWhitespace = strURL.replacingOccurrences(of: " ", with: "%20", options: .regularExpression)
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: URL(string: stringWithoutWhitespace), placeholderImage: UIImage(named: placeholderImage))
    }
}
