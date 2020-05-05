//
//  UserDetailViewController.swift
//  TinderCard
//
//  Created by Chung Han Hsin on 2020/5/1.
//  Copyright © 2020 Chung Han Hsin. All rights reserved.
//

import UIKit
import SwipeViewController

protocol UserDetailViewControllerDataSource: AnyObject {
  func userDetailViewControllerCellsClass(_ userDetailVC: UserDetailViewController) -> [AnyClass]
  func userDetailViewControllerNumberOfCell(_ userDetailVC: UserDetailViewController) -> Int
  func userDetailViewControllerTableViewBackgroundViewHeight(_ userDetailVC: UserDetailViewController) -> CGFloat
  func userDetailViewControllerTableViewUserImages(_ userDetailVC: UserDetailViewController) -> [UIImage]
}

protocol UserDetailViewControllerDelegate: AnyObject {
  func userDetailViewController(_ userDetailVC: UserDetailViewController, didSelectRowAt indexPath: IndexPath)
}

public class UserDetailViewController: UIViewController {
  
  weak var dataSource: UserDetailViewControllerDataSource?
  weak var delegate: UserDetailViewControllerDelegate?
  
  fileprivate lazy var tableView = makeTableView()
  fileprivate lazy var swipePhotoViewController = makeSwipeViewController()
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    registerAllCells()
    view.backgroundColor = .white
    setupLayout()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setBackgroundViewOfTableView(tableView: tableView)
  }
}


extension UserDetailViewController {
  
  fileprivate func makeScrollView() -> UIScrollView {
    let scrollView = UIScrollView()
    scrollView.isScrollEnabled = true
    scrollView.delegate = self
    return scrollView
  }
  fileprivate func makeTableView() -> UITableView {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }
  
  public func registerAllCells(){
    guard let dataSource = dataSource else {
      fatalError("🚨 You have to set dataSource for UserDetailViewController")
    }
    let cellClassTypes = dataSource.userDetailViewControllerCellsClass(self)
    cellClassTypes.forEach {
      tableView.register($0.self, forCellReuseIdentifier: String(describing: $0.self))
    }
  }
  
  fileprivate func setBackgroundViewOfTableView(tableView: UITableView) {
    guard let dataSource = dataSource else {
      fatalError("🚨 You have to set dataSource for UserDetailViewController")
    }
    let heightOfBackgroundView = dataSource.userDetailViewControllerTableViewBackgroundViewHeight(self)
    addChild(swipePhotoViewController)
    guard let myBackgroundView = swipePhotoViewController.view else {
      print("🛑 Check the swipePhotoViewController, cauz there doesn't have the view.")
      return
    }
    
    tableView.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: heightOfBackgroundView))
    tableView.backgroundView?.addSubview(myBackgroundView)
    myBackgroundView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: heightOfBackgroundView)
    
    let offSetDummyView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: heightOfBackgroundView))
    offSetDummyView.alpha = 0.0
    tableView.tableHeaderView = offSetDummyView
  }
  
  fileprivate func makeSwipeViewController() -> SwipeViewController {
    guard let dataSource = dataSource else {
      fatalError("🚨 You have to set dataSource for UserDetailViewController")
    }
    let images = dataSource.userDetailViewControllerTableViewUserImages(self)
    var photoViewControllers = [PhotoViewController]()
    for index in 0 ... (images.count - 1) {
      let photoViewController = PhotoViewController(index: index)
      photoViewController.dataSource = self
      photoViewControllers.append(photoViewController)
    }
    
    let vc = SwipeViewController(viewControllers: photoViewControllers)
    vc.dataSource = self
    return vc
  }
  
  fileprivate func setupLayout() {
    view.addSubview(tableView)
    tableView.fillSuperView(padding: .init(top: 44, left: 0, bottom: 44, right: 0))
  }
}

extension UserDetailViewController: UITableViewDataSource{
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let dataSource = dataSource else {
      fatalError("🚨 You have to set dataSource for UserDetailViewController")
    }
    return dataSource.userDetailViewControllerNumberOfCell(self)
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let dataSource = dataSource else {
      fatalError("🚨 You have to set dataSource for UserDetailViewController")
    }
    let cellClassTypes = dataSource.userDetailViewControllerCellsClass(self)
    for (index, cellClassType) in cellClassTypes.enumerated() {
      let indexPath = IndexPath(item: index, section: 0)
      let identifier = String(describing: cellClassType.self)
      let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
      cell.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
      return cell
    }
    return tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
  }
  
  
}

extension UserDetailViewController: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.userDetailViewController(self, didSelectRowAt: indexPath)
  }
}

extension UserDetailViewController: PhotoViewControllerDataSource {
  func photoViewControllerPhoto(_ photoViewController: PhotoViewController, index: Int) -> UIImage {
    guard let dataSource = dataSource else {
      fatalError("🚨 You have to set dataSource for UserDetailViewController")
    }
    let image = dataSource.userDetailViewControllerTableViewUserImages(self)[index]
    return image
  }
}

extension UserDetailViewController: SwipeViewControllerDataSource {
  public func swipeViewControllerIsAutoScrolling(_ swipeViewController: SwipeViewController) -> Bool {
    return true
  }
  
  public func swipeViewControllerTimeIntervalOfAutoScrolling(_ swipeViewController: SwipeViewController) -> TimeInterval {
    return 2
  }
}

extension UserDetailViewController: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //讓圖片不要是正方形的
    let extraSwipingHeight: CGFloat = 60
    let changeY = -scrollView.contentOffset.y
    let width = max(view.frame.width + changeY * 2, view.frame.width)
    let swipingView = swipePhotoViewController.view!
    swipingView.frame = CGRect.init(x: min(-changeY, 0) , y: min(-changeY, 0), width: width, height: width + extraSwipingHeight)
  }
}
