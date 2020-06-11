//
//  MessageViewController.swift
//  Chat
//
//  Created by Ta Huy Hung on 5/19/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import Foundation
import UIKit

class ManageMessView : UICollectionViewController {
    
    @IBOutlet var colView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    
}
