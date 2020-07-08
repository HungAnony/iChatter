//
//  String.swift
//  Chat
//
//  Created by Ta Huy Hung on 6/22/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit

extension String{
    static func formatTime(time : TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}
