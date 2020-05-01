//
//  MainViewController.swift
//  TinderCard
//
//  Created by Chung Han Hsin on 2020/4/29.
//  Copyright © 2020 Chung Han Hsin. All rights reserved.
//

import UIKit
import TinderSlidedCard

class MainViewController: UIViewController {
  fileprivate lazy var likeButton = makeLikeButton()
  fileprivate lazy var refreshAllCardButton = makeRefreshAllCardsButton()
  fileprivate lazy var disLikeButton = makeDislikeButton()

  lazy var cards = MainViewModel.makeCards1()
  
  let cardDeskView = CardDeskView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(cardDeskView)
    cardDeskView.dataSource = self
    cardDeskView.delegate = self
    
    cardDeskView.fillSuperView(padding: .init(top: 50, left: 5, bottom: 120, right: 5))
    cardDeskView.putIntoCards()
    
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    [likeButton, refreshAllCardButton, disLikeButton].forEach{
      stackView.addArrangedSubview($0)
    }
    
    view.addSubview(stackView)
    stackView.anchor(top: cardDeskView.bottomAnchor, bottom: view.bottomAnchor, leading: cardDeskView.leadingAnchor, trailing: cardDeskView.trailingAnchor, padding: .init(top: 20, left: 0, bottom: view.safeAreaInsets.bottom, right: 0))
  }
}

extension MainViewController: CardDeskViewDataSource {
  func cardDeskViewDetailIcon(_ cardDeskView: CardDeskView) -> UIImage {
    return MainViewModel.makeDetailIcon()
  }
  
  func cardDeskViewLikeIcon(_ cardDeskView: CardDeskView) -> UIImage {
    return MainViewModel.makeLikeIcon()
  }
  
  func cardDeskViewDislikeIcon(_ cardDeskView: CardDeskView) -> UIImage {
    return MainViewModel.makeDislikeIcon()
  }
  
  func cardDeskViewAllCardViewModels(_ cardDeskView: CardDeskView) -> [CardViewModel] {
    return cards
  }
}

extension MainViewController: CardDeskViewDelegate {
  func cardDeskViewDidDetailButtonPress(_ cardDeskView: CardDeskView, cardViewModel: CardViewModel, sender: UIButton) {
    print("User did press \(cardViewModel.name)'s detail button")
  }
  
  func cardDeskViewDidSlide(_ cardDeskView: CardDeskView, cardViewModel: CardViewModel) {
    print("User did slide \(cardViewModel.name)")
  }
  
  func cardDeskViewDidCancelSlide(_ cardDeskView: CardDeskView, cardViewModel: CardViewModel) {
    print("User cancel slide: \(cardViewModel.name)")
  }
  
  func cardDeskViewSliding(_ cardDeskView: CardDeskView, cardViewModel: CardViewModel, translation: CGPoint) {
    print("User panned \(translation.x)")
  }
  
  func cardDeskViewWillLikeCard(_ cardDeskView: CardDeskView, cardViewModel: CardViewModel) {
    print("user like \(cardViewModel.name)")
  }
  
  func cardDeskViewWillDislikeCard(_ cardDeskView: CardDeskView, cardViewModel: CardViewModel) {
    print("user dislike \(cardViewModel.name)")
  }
  
  func cardDeskViewDidRefreshAllCards(_ cardDeskView: CardDeskView, cardViewModels: [CardViewModel]) {
    print("cardViewModels: \(cardViewModels)")
  }
}



extension MainViewController {
  fileprivate func makeLikeButton() -> UIButton {
    let btn = UIButton(type: .system)
    btn.setTitle("Like", for: .normal)
    btn.setTitleColor(UIColor.white, for: .normal)
    btn.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    btn.addTarget(self, action: #selector(didLikeButtonPress(sender:)), for: .touchUpInside)
    return btn
  }
  
  @objc func didLikeButtonPress(sender: UIButton) {
    cardDeskView.likeCurrentCard()
  }
  
  fileprivate func makeRefreshAllCardsButton() -> UIButton {
    let btn = UIButton(type: .system)
    btn.setTitle("Refresh All Cards", for: .normal)
    btn.setTitleColor(UIColor.white, for: .normal)
    btn.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    btn.addTarget(self, action: #selector(didRefreshAllCardsPress(sender:)), for: .touchUpInside)
    return btn
  }
  
  @objc func didRefreshAllCardsPress(sender: UIButton) {
    cards = MainViewModel.makeCards2()
    cardDeskView.putIntoCards()
  }
  
  fileprivate func makeDislikeButton() -> UIButton {
    let btn = UIButton(type: .system)
    btn.setTitle("Dislike", for: .normal)
    btn.setTitleColor(UIColor.white, for: .normal)
    btn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    btn.addTarget(self, action: #selector(didDislikeButtonPress(sender:)), for: .touchUpInside)
    return btn
  }
  
  @objc func didDislikeButtonPress(sender: UIButton) {
    cardDeskView.dislikeCurrentCard()
  }
  
}
