//
//  SearchParameterCell.swift
//  Searchify
//
//  Created by MAHESHWARAN on 22/05/23.
//

import Foundation
import UIKit

class SearchParameterCell: UICollectionViewCell {
  
  static let identifier = "SearchParameterCell"
  
  // MARK: - Outlets
  
  let detailLabel: UILabel = {
    $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    $0.textColor = .black
    $0.textAlignment = .center
    return $0
  }(UILabel())
  
  lazy var imageView: UIImageView = {
    
    $0.image =  UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(
      weight: .semibold))?.withTintColor(.white, renderingMode: .alwaysOriginal)
    return $0
  }(UIImageView())
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    addAccessibilityLabels()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
    addAccessibilityLabels()
  }
  
  override var isSelected: Bool {
    didSet {
      updateContainerView(isSelected: isSelected)
    }
  }
  
  // MARK: - Appearance
  
  private func setupView() {
    contentView.layer.borderColor = UIColor.gray.cgColor
    contentView.layer.borderWidth = 0.5
    contentView.layer.cornerRadius = 16
    contentView.layer.masksToBounds = true
  }
  
  func configureView(using filterOption: SearchFilterOption, isSelected: Bool = false) {
    detailLabel.text = filterOption.title
    updateContainerView(isSelected: isSelected)
  }
  
  private func updateContainerView(isSelected: Bool) {
    contentView.backgroundColor = isSelected ? .blue : .systemBackground
    detailLabel.textColor = isSelected ? .white : .blue
    detailLabel.textAlignment = isSelected ? .center : .left
    imageView.isHidden = !isSelected
    configureConstraints()
  }
  
  private func configureConstraints() {
    contentView.addSubview(imageView)
    contentView.addSubview(detailLabel)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    detailLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      detailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      detailLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
      
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
      imageView.centerYAnchor.constraint(equalTo: detailLabel.centerYAnchor),
      imageView.trailingAnchor.constraint(equalTo: detailLabel.leadingAnchor, constant: -3),
      imageView.widthAnchor.constraint(equalToConstant: 20),
      imageView.heightAnchor.constraint(equalToConstant: 20),
    ])
  }
  
  private func addAccessibilityLabels() {
    imageView.accessibilityIdentifier = "imageView"
    detailLabel.accessibilityIdentifier = "detailLabel"
  }
}

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

