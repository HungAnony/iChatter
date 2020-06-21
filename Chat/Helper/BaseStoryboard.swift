//
//  BaseStoryboard.swift
//  Chat
//
//  Created by Ta Huy Hung on 5/30/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import Foundation
import UIKit

class BaseStoryboard {
    public func getIntialViewController() -> UIViewController{
        let storyboardName = self.storyboardName()
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()!
    }
    
    
    public func getViewControllerByIdentifier(identifier : String) -> UIViewController{
        let storyboardName = self.storyboardName()
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(identifier: identifier)
    }
    
    
    func storyboardName() -> String{
        return ""
    }
}
