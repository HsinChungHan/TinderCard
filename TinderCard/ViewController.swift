//
//  ViewController.swift
//  TinderCard
//
//  Created by Chung Han Hsin on 2020/4/29.
//  Copyright © 2020 Chung Han Hsin. All rights reserved.
//

import UIKit

//MARK: - Mock data
let imageNames = [
	"lady1-a",
  "lady1-b",
  "lady1-c",
  "lady1-d",
]

class ViewController: UIViewController {

  var cardView = Card()
  let cardViewModel = CardViewModel()
  
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

  func cardFirstPhotoImage(_ cardView: Card) -> UIImage {
    return UIImage(named: imageNames[0])!
  }
  
  func cardPhotos(_ cardView: Card) -> [UIImage] {
    var images = [UIImage]()
    //TODO: - Mock Data, it should be replaced by fetching photos from Firebase storage in the future
    imageNames.forEach{
      let img = UIImage(named: $0)!
      images.append(img)
    }
    return images
  }
  
  func cardInformationAttributedText(_ cardView: Card) -> NSAttributedString {
    //TODO: - Write an extension for translating String to NSAttributedString
    let nameAtrributedString = NSAttributedString.init(string: "name", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
    return nameAtrributedString
  }
  
  func cardInformationTextAlignment(_ cardView: Card) -> NSTextAlignment {
    return .left
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
