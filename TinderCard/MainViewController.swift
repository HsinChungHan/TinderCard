//
//  MainViewController.swift
//  TinderCard
//
//  Created by Chung Han Hsin on 2020/4/29.
//  Copyright © 2020 Chung Han Hsin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  let cardDeskView = CardDeskView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(cardDeskView)
    cardDeskView.dataSource = self
    cardDeskView.fillSuperView(padding: .init(top: 30, left: 30, bottom: 30, right: 30))
    cardDeskView.putIntoCards()
  }
}

extension MainViewController: CardDeskViewDataSource {
  func cardDeskViewAllCardViewModels(_ cardDeskView: CardDeskView) -> [CardViewModel] {
    let photos = [
    	UIImage(named: "lady1-a")!,
      UIImage(named: "lady1-b")!,
      UIImage(named: "lady1-c")!,
      UIImage(named: "lady1-d")!,
    ]
    
    let cardViewModels = [
      CardViewModel(name: "Hsin", textAlignment: .center, photos: photos),
      CardViewModel(name: "Hsin", textAlignment: .center, photos: photos),
      CardViewModel(name: "Katy", textAlignment: .left, photos: photos),
      CardViewModel(name: "Annie", textAlignment: .center, photos: photos),
      CardViewModel(name: "Ting", textAlignment: .left, photos: photos)
    ]
    return cardViewModels
  }
}
