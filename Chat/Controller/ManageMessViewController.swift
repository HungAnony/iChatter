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
        colView.register(ManageMessViewCell.self, forCellWithReuseIdentifier: "cell_id")
        navigationItem.title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell_id", for: indexPath)
    }
    
    
    
    
    
}
