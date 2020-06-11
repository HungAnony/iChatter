//
//  ViewController.swift
//  Chat
//
//  Created by Ta Huy Hung on 5/8/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }


}

