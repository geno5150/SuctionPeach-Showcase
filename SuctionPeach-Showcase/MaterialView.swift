//
//  MaterialView.swift
//  SuctionPeach-Showcase
//
//  Created by Geno Erickson on 12/21/15.
//  Copyright © 2015 SuctionPeach. All rights reserved.
//

import UIKit

class MaterialView: UIView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOffset = CGSize(width: 0,height: 0)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
