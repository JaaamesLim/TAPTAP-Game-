//
//  IndicatorClass.swift
//  InDot
//
//  Created by JAMES GOT GAME 07 on 28/6/17.
//  Copyright © 2017 Hamaste. All rights reserved.
//

import UIKit

class IndicatorClass: UIView {
    
    private var pivot: CGPoint!
    private var torque: CGFloat = 0
    private var const_torque: CGFloat!
    private var radius: CGFloat!
    private var angle: CGFloat = 0
    private var sign = true
    
    public func setup(p: CGPoint, t: CGFloat, r: CGFloat, colour: UIColor) {
        pivot = p
        torque = t
        radius = r
        
        const_torque = torque * 1.5
        
        self.frame.size = CGSize(width: radius*2, height: radius*2)
        self.layer.borderWidth = radius/2
        self.layer.borderColor = colour.cgColor
        self.layer.cornerRadius = r
    }
    
    public func orbit() {
        angle += 1
        let y = torque * sin(angle/360 * 2*CGFloat.pi)
        let x = torque * cos(angle/360 * 2*CGFloat.pi)
        
        self.center = CGPoint(x: pivot.x + x, y: pivot.y + y)
    }
    
    public func extend() {
        if sign && torque < const_torque {
            torque += 1
        } else if !sign && torque > 0 {
            torque -= 1
        } else {
            sign = !sign
        }
        
        let y = torque * sin(angle/360 * 2*CGFloat.pi)
        let x = torque * cos(angle/360 * 2*CGFloat.pi)
        
        self.center = CGPoint(x: pivot.x + x, y: pivot.y + y)
    }
    
    func getPoint() -> CGPoint {
        let y = torque * sin(angle/360 * 2*CGFloat.pi)
        let x = torque * cos(angle/360 * 2*CGFloat.pi)
        
        return CGPoint(x: pivot.x + x, y: pivot.y + y)
        
    }

}
