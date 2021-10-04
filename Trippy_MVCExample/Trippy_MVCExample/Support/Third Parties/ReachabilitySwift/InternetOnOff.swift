//
//  InternetOnOff.swift
//  Cricket Line
//
//  Created by TBI-iOS-02 on 11/05/20.
//  Copyright © 2020 TBI-iOS-02. All rights reserved.
//

import UIKit

class InternetOnOff: UIView
{
    var img_view = UIImageView()
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        comman_init()
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        comman_init()
    }
    
    
    func comman_init()
    {
        self.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        
        img_view.isUserInteractionEnabled = false
        img_view.frame = CGRect(x: 0.0, y: (self.frame.height/4), width: self.frame.width, height: (self.frame.height-(self.frame.height/4))) //self.bounds
        img_view.image = UIImage(named: "off_line")
        img_view.contentMode = .scaleAspectFill
        img_view.clipsToBounds = true
        
        img_view.roundCornersToTop(cornerRadius: 32.0)
        
        addSubview(img_view)
        //img_view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
