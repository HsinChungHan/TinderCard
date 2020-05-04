//
//  UserDetailViewController.swift
//  TinderCard
//
//  Created by Chung Han Hsin on 2020/5/1.
//  Copyright © 2020 Chung Han Hsin. All rights reserved.
//

import UIKit

protocol UserDetailViewControllerDataSource: AnyObject {
  func userDetailViewControllerCellsClass(_ userDetailVC: UserDetailViewController) -> [AnyClass]
  func userDetailViewControllerNumberOfCell(_ userDetailVC: UserDetailViewController) -> Int
  func userDetailViewControllerTableViewBackgroundViewHeight(_ userDetailVC: UserDetailViewController) -> CGFloat
  func userDetailViewControllerTableViewBackgroundView(_ userDetailVC: UserDetailViewController) -> UIView
}

protocol UserDetailViewControllerDelegate: AnyObject {
  func userDetailViewController(_ userDetailVC: UserDetailViewController, didSelectRowAt indexPath: IndexPath)
}

public class UserDetailViewController: UIViewController {
  fileprivate lazy var tableView = makeTableView()
  weak var dataSource: UserDetailViewControllerDataSource?
  weak var delegate: UserDetailViewControllerDelegate?

  
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    registerAllCells()
    setBackgroundViewOfTableView(tableView: tableView)
    
  }
}


extension UserDetailViewController {
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
    let backgroundView = dataSource.userDetailViewControllerTableViewBackgroundView(self)
    backgroundView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: heightOfBackgroundView)
    
    tableView.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: heightOfBackgroundView))
    tableView.backgroundView?.addSubview(backgroundView)
    
    let offSetDummyView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: heightOfBackgroundView))
    offSetDummyView.backgroundColor = .clear
    tableView.tableHeaderView = offSetDummyView
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
