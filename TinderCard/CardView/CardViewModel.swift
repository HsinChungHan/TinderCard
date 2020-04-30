//
//  CardViewModel.swift
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


class CardViewModel {
  var currentPhotoIndex = 0
  let name: String
  let textAlignment: NSTextAlignment
  let photos: [UIImage]
  //TODO: - It's mock data
  lazy var attributedString = translationStringToNSAttributedString(str: name)
  
  init(name: String, textAlignment: NSTextAlignment, photos: [UIImage]) {
    self.name = name
    self.textAlignment = textAlignment
    self.photos = photos
  }

  func getPhotoMoveForwardIndex(currentIndex: Int, countOfPhotos: Int) -> Int {
    return min(currentIndex + 1, countOfPhotos - 1)
  }
  
  func getPhotoBackLastIndex(currentIndex: Int, countOfPhotos: Int) -> Int {
    return max(currentIndex - 1, 0)
  }
  
}

extension CardViewModel {
  func makePhotos(imageNames: [String]) -> [UIImage] {
    var images = [UIImage]()
    imageNames.forEach{
      images.append(UIImage(named: $0)!)
    }
    return images
  }
  
  func translationStringToNSAttributedString(str: String) -> NSAttributedString {
    return NSAttributedString(string: str, attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
  }
}
