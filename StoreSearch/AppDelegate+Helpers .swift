//
//  AppDelegate+Helpers .swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 19/03/2022.
//

import UIKit

extension AppDelegate {
    
    func switchToSeachViewController() {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainVC = UINavigationController(rootViewController: SearchViewController())
        window.rootViewController = mainVC
        self.window = window
        self.window?.makeKeyAndVisible()
        
    }
    
    func switchToSplitViewController() {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let splitVC = UISplitViewController()
        let searchView = SearchViewController()
        let detailView = DetailViewController()
        let navigationView = UINavigationController(rootViewController: detailView)
        
        splitVC.viewControllers = [searchView, navigationView]
        
        detailView.navigationItem.leftBarButtonItem = splitVC.displayModeButtonItem
        
        searchView.splitViewDetail = detailView
        
        window.rootViewController = splitVC
        self.window = window
        self.window?.makeKeyAndVisible()
        
    }
    
    
}
