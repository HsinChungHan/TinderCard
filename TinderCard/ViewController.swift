//
//  ViewController.swift
//  TinderCard
//
//  Created by Chung Han Hsin on 2020/4/29.
//  Copyright © 2020 Chung Han Hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var cardView = Card()
  lazy var cardViewModel = CardViewModel.init(name: "Hsin", textAlignment: .left)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cardView.dataSource = self
    cardView.delegate = self
    
    view.addSubview(cardView)
    cardView.fillSuperView(padding: .init(top: 30, left: 30, bottom: 30, right: 30))
    cardView.reloadData()
  }
}

extension ViewController: CardDataSource {
  
  func cardCurrentPhotoIndex(_ card: Card) -> Int {
    return cardViewModel.currentPhotoIndex
  }
  
  func cardPhotos(_ cardView: Card) -> [UIImage] {
    return cardViewModel.images
  }
  
  func cardInformationAttributedText(_ cardView: Card) -> NSAttributedString {
    return cardViewModel.attributedString
  }
  
  func cardInformationTextAlignment(_ cardView: Card) -> NSTextAlignment {
    return cardViewModel.textAlignment
  }
}

extension ViewController: CardDelegate {
  func cardPhototMoveForward(_ card: Card, currentPhotoIndex: Int, countOfPhotos: Int) {
    cardViewModel.currentPhotoIndex = cardViewModel.getPhotoMoveForwardIndex(currentIndex: currentPhotoIndex, countOfPhotos: countOfPhotos)
    card.reloadData()
  }
  
  func cardPhototBackLast(_ card: Card, currentPhotoIndex: Int, countOfPhotos: Int) {
    cardViewModel.currentPhotoIndex = cardViewModel.getPhotoBackLastIndex(currentIndex: currentPhotoIndex, countOfPhotos: countOfPhotos)
    card.reloadData()
  }
}
