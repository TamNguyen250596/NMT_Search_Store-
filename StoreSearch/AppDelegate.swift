//
//  AppDelegate.swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 10/01/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    //MARK: Properties
    var window: UIWindow?
    

    //MARK: App cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        uiShouldBeShow()
        
        return true
    }
    
    //MARK: Helpers
    private func uiShouldBeShow() {
        
        switch UIDevice.current.userInterfaceIdiom {
            
        case .phone:
            
            switchToSeachViewController()
            break
            
        case .pad, .mac:
            
            switchToSplitViewController()
            break

        default:
            
            switchToSeachViewController()
            break
            
        }
        
    }
    
}

