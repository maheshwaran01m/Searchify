//
//  SearchParameterListCell.swift
//  Searchify
//
//  Created by MAHESHWARAN on 22/05/23.
//

import Foundation
import UIKit

protocol SearchParamsListCellDelegate: AnyObject {
  func didTapOnClearButton(_ cell: SearchParamsListCell)
}

class SearchParamsListCell: UICollectionViewCell {
  
  weak var delegate: SearchParamsListCellDelegate?
  
  let detailLabel: UILabel = {
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = .black
    $0.textAlignment = .center
    return $0
  }(UILabel())
  
  lazy var clearButton: UIButton = {
    let cancelImage = UIImage(systemName: "xmark.circle.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
    $0.setImage(cancelImage, for: .normal)
    $0.addTarget(self, action: #selector(clearButtonClicked(_:)), for: .touchUpInside)
    return $0
  }(UIButton())
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    addAccessibilityLabels()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    detailLabel.text = nil
  }
  
  // MARK: - Appearance
  
  private func setupView() {
    contentView.backgroundColor = .systemBackground
    contentView.layer.borderColor = UIColor.gray.cgColor
    contentView.layer.borderWidth = 0.5
    contentView.layer.cornerRadius = 6.0
    contentView.layer.masksToBounds = true
    configureConstraints()
  }
  
  func configureView(using value: String) {
    detailLabel.text = value
  }
  
  private func configureConstraints() {
    
    let horizontalStack = UIStackView(arrangedSubviews: [detailLabel, clearButton])
    horizontalStack.axis = .horizontal
    horizontalStack.spacing = 5
    horizontalStack.distribution = .fill
    contentView.addSubview(horizontalStack)
    horizontalStack.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
      horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
      horizontalStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
      horizontalStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
    ])
  }
  
  @objc private func clearButtonClicked(_ sender: UIButton) {
    delegate?.didTapOnClearButton(self)
  }
  
  private func addAccessibilityLabels() {
    detailLabel.accessibilityIdentifier = "detailLabel"
    clearButton.accessibilityIdentifier = "clearButon"
  }
}
