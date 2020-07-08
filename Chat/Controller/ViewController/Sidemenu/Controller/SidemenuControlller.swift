//
//  SidemenuControlller.swift
//  Chat
//
//  Created by Ta Huy Hung on 7/8/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import Foundation
import UIKit

class SideMenuControlller : UIViewController,UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonInfoViewCell") as! PersonInfoViewCell
        return cell
    }
    
    
}
