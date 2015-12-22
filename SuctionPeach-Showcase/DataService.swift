//
//  DataService.swift
//  SuctionPeach-Showcase
//
//  Created by Geno Erickson on 12/21/15.
//  Copyright © 2015 SuctionPeach. All rights reserved.
//

import Foundation
import Firebase
class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "https://resplendent-fire-7815.firebaseio.com")
    var REF_BASE: Firebase {
        return _REF_BASE
    }
}