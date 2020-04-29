//
//  CardView.swift
//  TinderCard
//
//  Created by Chung Han Hsin on 2020/4/29.
//  Copyright © 2020 Chung Han Hsin. All rights reserved.
//

import UIKit

//MARK: - Instance
fileprivate let threhold: CGFloat = 120
fileprivate let barDeselectColor = UIColor.init(white: 0, alpha: 0.1)
fileprivate let barSelectColor = UIColor.white

//MARK: - CardDataSource
protocol CardDataSource: AnyObject {
  func cardPhotos(_ card: Card) -> [UIImage]
  func cardInformationAttributedText(_ card: Card) -> NSAttributedString
  func cardInformationTextAlignment(_ card: Card) -> NSTextAlignment
  func cardCurrentPhotoIndex(_ card: Card) -> Int
}

//MARK: - CardDelegate
protocol CardDelegate: AnyObject {
  func cardPhototMoveForward(_ card: Card, currentPhotoIndex: Int, countOfPhotos: Int)
  func cardPhototBackLast(_ card: Card, currentPhotoIndex: Int, countOfPhotos: Int)
}

class Card: UIView {
  
  //MARK: - Properties
  weak var dataSource: CardDataSource?
  weak var delegate: CardDelegate?
  
  fileprivate lazy var imageView = makePhotoImageView()
  fileprivate lazy var informationLabel = makeInformationLabel()
  fileprivate lazy var gradientLayer = makeGradientLayer()
  fileprivate lazy var barStackView = makeBarStackView()
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupLayout()
    layer.addSublayer(gradientLayer)
    addPanGesture()
    addTapGesture()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}





extension Card {
  
  //MARK: - Lazy initialization
  fileprivate func makePhotoImageView() -> UIImageView {
    let imv = UIImageView()
    imv.contentMode = .scaleAspectFill
    imv.clipsToBounds = true
    return imv
  }
  
  fileprivate func makeInformationLabel() -> UILabel {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
    label.numberOfLines = 0
    return label
  }
  
  fileprivate func makeGradientLayer() -> CAGradientLayer {
    let layer = CAGradientLayer()
    layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    layer.locations = [0.5, 1.1]
    return layer
  }
  
  fileprivate func makeBarStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 4.0
    stackView.distribution = .fillEqually
    return stackView
  }
  
  fileprivate func makeBars(counts: Int) -> [UIView] {
    var views = [UIView]()
    for index in 0 ..< counts {
      let view = UIView()
      view.backgroundColor = (index == 0) ? barSelectColor : barDeselectColor
      views.append(view)
    }
    return views
  }
  
  
  //MARK: - Pan Gesture
  fileprivate func addPanGesture() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    addGestureRecognizer(panGesture)
  }
  
  @objc func handlePan(gesture: UIPanGestureRecognizer){
    switch gesture.state {
      case .began:
        superview?.subviews.forEach({ (subview) in
          subview.layer.removeAllAnimations()
        })
      case .changed:
        handleChanged(gesture)
      case .ended:
        handleEnded(gesture)
      default:
        return
    }
  }
  
  fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: nil)
    //convert degrees into radians
    let degrees: CGFloat = translation.x / 20
    let angle: CGFloat = degrees * .pi / 180
    let rotationTransformation = CGAffineTransform.init(rotationAngle: angle)
    transform = rotationTransformation.translatedBy(x: translation.x, y: translation.y)
  }
  
  fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
    let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
    let shouldDismissedCard = abs(gesture.translation(in: nil).x) > threhold
    if shouldDismissedCard{
      if translationDirection == 1{
        performSwipAnimation(translation: 700, angle: 15)
      }else{
        performSwipAnimation(translation: -700, angle: -15)
      }
    }else{
      UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {[unowned self] in
        self.transform = .identity
      })
    }
  }
  
  fileprivate func performSwipAnimation(translation: CGFloat, angle: CGFloat) {
    let translationAnimation = CABasicAnimation.init(keyPath: "position.x")
    translationAnimation.toValue = translation
    translationAnimation.duration = 0.5
    translationAnimation.fillMode = .forwards
    translationAnimation.isRemovedOnCompletion = false
    translationAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
    
    let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
    rotationAnimation.toValue = angle * CGFloat.pi / 180
    rotationAnimation.duration = 0.5
    CATransaction.setCompletionBlock {
      self.removeFromSuperview()
    }
    
    self.layer.add(translationAnimation, forKey: "translation")
    self.layer.add(rotationAnimation, forKey: "rotation")
    CATransaction.commit()
  }
  
  
  //MARK: - Tap Gesture
  fileprivate func addTapGesture(){
    let tapGetsure = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
    addGestureRecognizer(tapGetsure)
  }
  
  @objc func handleTap(gesture: UITapGestureRecognizer){
    guard let dataSource = dataSource else {
      fatalError("🚨 You have to set Card's dataSourece")
    }
    let tapLocation = gesture.location(in: nil)
    let shouldAdvanceNextPhoto = tapLocation.x > frame.width/2 ? true : false
    let countOfPhotos = dataSource.cardPhotos(self).count
    let currentIndexOfPhoto = dataSource.cardCurrentPhotoIndex(self)
    if shouldAdvanceNextPhoto{
      delegate?.cardPhototMoveForward(self, currentPhotoIndex: currentIndexOfPhoto, countOfPhotos: countOfPhotos)
    }else{
      delegate?.cardPhototBackLast(self, currentPhotoIndex: currentIndexOfPhoto, countOfPhotos: countOfPhotos)
    }
  }
  
  
  //MARK: - Layout function
  fileprivate func setupLayout() {
    layer.cornerRadius = 10.0
    clipsToBounds = true
    
    addSubview(imageView)
    addSubview(barStackView)
    addSubview(informationLabel)
    
    imageView.fillSuperView()
    barStackView.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    informationLabel.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16), size: .zero)
  }
  
  
  //MARK: - put data in UI component
  func reloadData() {
    guard let dataSource = dataSource else {
      fatalError("🚨 You have to set Card's dataSourece")
    }
    
    let userPhotos = dataSource.cardPhotos(self)
    let userPhotoCurrentIndex = dataSource.cardCurrentPhotoIndex(self)
    let attributedTextOfInformationLabel = dataSource.cardInformationAttributedText(self)
    let textAlignmentOfInformationLabel = dataSource.cardInformationTextAlignment(self)
    
    imageView.image = userPhotos[userPhotoCurrentIndex]
    informationLabel.attributedText = attributedTextOfInformationLabel
    informationLabel.textAlignment = textAlignmentOfInformationLabel
    
    //TODO: - use a function to refactor it
    if barStackView.arrangedSubviews.isEmpty {
      makeBars(counts: userPhotos.count).forEach{
        barStackView.addArrangedSubview($0)
      }
    }else {
      barStackView.arrangedSubviews.forEach{
        $0.backgroundColor = barDeselectColor
      }
      barStackView.subviews[userPhotoCurrentIndex].backgroundColor = barSelectColor
    }
  }
  
}
