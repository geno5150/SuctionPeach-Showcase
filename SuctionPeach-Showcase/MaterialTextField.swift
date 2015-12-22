//
//  MaterialTextField.swift
//  SuctionPeach-Showcase
//
//  Created by Geno Erickson on 12/21/15.
//  Copyright © 2015 SuctionPeach. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).CGColor
        layer.borderWidth = 1.0
        
    }
    
    //For placeholder
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10.0, 0)
    }

    //For editable text
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
            return CGRectInset(bounds, 10.0, 0)
    }
}
