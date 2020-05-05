//
//  PhotoViewController.swift
//  TinderCard
//
//  Created by Chung Han Hsin on 2020/5/5.
//  Copyright © 2020 Chung Han Hsin. All rights reserved.
//

import UIKit

protocol PhotoViewControllerDataSource: AnyObject {
  func photoViewControllerPhoto(_ photoViewController: PhotoViewController, index: Int) -> UIImage
}

class PhotoViewController: UIViewController {
  weak var dataSource: PhotoViewControllerDataSource?
  
  fileprivate lazy var imageView = makeImageView()
  
  let index: Int
  
  init(index: Int) {
    self.index = index
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
  }
}

extension PhotoViewController {
  fileprivate func makeImageView() -> UIImageView {
    guard let dataSource = dataSource else {
      fatalError("🚨 You have to set dataSource for PhotoViewController")
    }
    let image = dataSource.photoViewControllerPhoto(self, index: index)
    let imv = UIImageView()
    imv.image = image
    imv.contentMode = .scaleAspectFill
    imv.clipsToBounds = true
    return imv
  }
  
  fileprivate func setupLayout() {
    view.addSubview(imageView)
    imageView.fillSuperView()
  }
}
