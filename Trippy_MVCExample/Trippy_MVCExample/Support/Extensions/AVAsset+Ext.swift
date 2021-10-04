//
//  AVAsset+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit
import AVFoundation


extension AVAsset
{
    var screenSize: CGSize?
    {
        if let track = tracks(withMediaType: .video).first
        {
            let size = __CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform)
            return CGSize(width: abs(size.width), height: abs(size.height))
        }
        return nil
    }
    
    var getAspectRatio: CGFloat
    {
        if let mediasize = self.screenSize
        {
            let mediaAspectRatio = CGFloat(mediasize.height / mediasize.width)
            return mediaAspectRatio
        }
        
        return 0.75
    }
    
}
