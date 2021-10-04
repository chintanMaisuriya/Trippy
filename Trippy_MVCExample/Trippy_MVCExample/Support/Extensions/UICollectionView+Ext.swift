//
//  UICollectionView+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit


extension UICollectionView
{
    func showNoDataLabel(_ strAltMsg: String, isScrollable: Bool)
    {
        let noDataView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let msglbl               = UILabel(frame: CGRect(x: 12, y: 25, width: self.bounds.size.width-24, height: self.bounds.size.height-50))
        msglbl.text          = strAltMsg
        msglbl.textAlignment = .center
        msglbl.font          = UIFont.systemFont(ofSize: Utils.setCustomFontSize(noramlSize: 18))
        msglbl.numberOfLines = 0
        msglbl.textColor     = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1) //UIColor(white: 0.9, alpha: 1.0)
        
        noDataView.addSubview(msglbl)
        
        self.isScrollEnabled = isScrollable
        self.backgroundView  = noDataView
    }
    
    func removeNoDataLabel()
    {
        self.isScrollEnabled = true
        self.backgroundView  = nil
    }
    
    func scrollToNearestVisibleCollectionViewCell()
    {
        self.decelerationRate                   = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView   = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex                    = -1
        var closestDistance: Float              = .greatestFiniteMagnitude
        
        for i in 0..<self.visibleCells.count
        {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            
            if distance < closestDistance
            {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        
        if closestCellIndex != -1
        {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func deselectAllItems(animated: Bool = false)
    {
        for indexPath in self.indexPathsForSelectedItems ?? []
        {
            self.deselectItem(at: indexPath, animated: animated)
        }
    }
}
