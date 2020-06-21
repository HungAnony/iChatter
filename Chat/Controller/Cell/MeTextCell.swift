//
//  MeTextCell.swift
//  Chat
//
//  Created by Ta Huy Hung on 5/19/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import Foundation
import UIKit

class MeTextCell: UITableViewCell {
    @IBOutlet weak var lblTextSent: UILabel!
    func bindData(_ data : String){
        lblTextSent.text = data
    }
    
}
