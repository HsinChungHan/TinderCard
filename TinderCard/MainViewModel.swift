//
//  MainViewModel.swift
//  TinderCard
//
//  Created by Chung Han Hsin on 2020/4/30.
//  Copyright © 2020 Chung Han Hsin. All rights reserved.
//
 
import UIKit
import TinderSlidedCard

class MainViewModel {
  
  static func makeCards1() -> [CardViewModel]{
    let photos1 = [
      UIImage(named: "lady1-a")!,
      UIImage(named: "lady1-b")!,
      UIImage(named: "lady1-c")!,
      UIImage(named: "lady1-d")!,
    ]
    
    let cardViewModels = [
      CardViewModel(name: "Hsin", textAlignment: .center, photos: photos1),
      CardViewModel(name: "Hsin", textAlignment: .center, photos: photos1),
      CardViewModel(name: "Katy", textAlignment: .left, photos: photos1),
      CardViewModel(name: "Annie", textAlignment: .center, photos: photos1),
      CardViewModel(name: "Ting", textAlignment: .left, photos: photos1)
    ]
    return cardViewModels
  }
  
  static func makeCards2() -> [CardViewModel]{
    let photos2 = [
      UIImage(named: "lady2-a")!,
      UIImage(named: "lady2-b")!,
      UIImage(named: "lady2-c")!,
      UIImage(named: "lady2-d")!,
      UIImage(named: "lady2-e")!,
    ]
    
    let cardViewModels = [
      CardViewModel(name: "Hsin", textAlignment: .center, photos: photos2),
      CardViewModel(name: "Hsin", textAlignment: .center, photos: photos2),
      CardViewModel(name: "Katy", textAlignment: .left, photos: photos2),
      CardViewModel(name: "Annie", textAlignment: .center, photos: photos2),
      CardViewModel(name: "Ting", textAlignment: .left, photos: photos2)
    ]
    return cardViewModels
  }
  
  static func makeLikeIcon() -> UIImage {
    return UIImage(named: "like")!
  }
  
  static func makeDislikeIcon() -> UIImage {
    return UIImage(named: "nope")!
  }
  
  static func makeDetailIcon() -> UIImage {
    return UIImage(named: "info_icon")!
  }
  
  static func makeOverallControllers() -> [UIViewController] {
    var overallVC = [UIViewController]()
    let colors: [UIColor] = [.blue, .brown, .cyan, .darkGray]
    colors.forEach {
      let vc = UIViewController()
      vc.view.backgroundColor = $0
      overallVC.append(vc)
    }
    return overallVC
  }
}

