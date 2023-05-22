//
//  SearchParameterCell.swift
//  Searchify
//
//  Created by MAHESHWARAN on 22/05/23.
//

import Foundation
import UIKit

/// ` Left Align the Cells in Collection View `
/// This Custom UICollectionViewFlowLayout, is used to solve the uneven spacing in collection cell,
/// it will provide equal padding between each cell in a collection view.
///
///    Usage:
///    let layout = CustomFlowLayout()
///    collectionView.collectionViewLayout = layout
///    collectionView.contentInsetAdjustmentBehavior = .always
///
/// Source: " https://stackoverflow.com/questions/22539979/
/// left-align-cells-in-uicollectionview/36016798#36016798 "
///
class CustomFlowLayout: UICollectionViewFlowLayout {
  
  let cellSpacing: CGFloat = 8.0
  
  override func layoutAttributesForElements(
    in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      
      self.minimumLineSpacing = 8.0
      self.sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
      
      let attributes = super.layoutAttributesForElements(in: rect)
      
      var leftMargin = sectionInset.left
      var maxY: CGFloat = -1.0
      attributes?.forEach { layoutAttribute in
        if layoutAttribute.frame.origin.y >= maxY {
          leftMargin = sectionInset.left
        }
        layoutAttribute.frame.origin.x = leftMargin
        leftMargin += layoutAttribute.frame.width + cellSpacing
        maxY = max(layoutAttribute.frame.maxY, maxY)
      }
      return attributes
    }
}

