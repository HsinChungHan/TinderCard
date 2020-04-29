//
//  CardViewModel.swift
//  TinderCard
//
//  Created by Chung Han Hsin on 2020/4/29.
//  Copyright © 2020 Chung Han Hsin. All rights reserved.
//

import Foundation

class CardViewModel {
  var currentPhotoIndex = 0

  func getPhotoMoveForwardIndex(currentIndex: Int, countOfPhotos: Int) -> Int {
    return min(currentIndex + 1, countOfPhotos - 1)
  }
  
  func getPhotoBackLastIndex(currentIndex: Int, countOfPhotos: Int) -> Int {
    return max(currentIndex - 1, 0)
  }
  
}
