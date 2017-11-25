//
//  PlatformClass.swift
//  InDot
//
//  Created by JAMES GOT GAME 07 on 29/6/17.
//  Copyright © 2017 Hamaste. All rights reserved.
//

import UIKit

class PlatformClass: UIView {
    
    public func setup(f: CGRect, colour: UIColor) {
        self.frame = f
        self.backgroundColor = colour
        self.alpha = 0.1
        self.layer.borderWidth = 5
        self.layer.borderColor = colour.cgColor
    }
    
}
