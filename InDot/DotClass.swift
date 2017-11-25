//
//  DotClass.swift
//  InDot
//
//  Created by JAMES GOT GAME 07 on 27/6/17.
//  Copyright © 2017 Hamaste. All rights reserved.
//

import UIKit

class DotClass: UIView {
    
    private var radius: CGFloat!
    
    public func setup(r: CGFloat, center: CGPoint, colour: UIColor) {
        radius = r
        
        self.frame.size = CGSize(width: radius*2, height: radius*2)
        self.center = center
        self.backgroundColor = colour
        self.layer.cornerRadius = r
    }
    
    public func collision(points: [DotClass], prev: CGPoint, curr: CGPoint) -> Bool {
        // Y = mX + c
        let m1 = gradient(prev, curr)
        let c1 = yIntercept(m1, prev)
        for i in 1..<points.count {
            let m2 = gradient(points[i].center, points[i-1].center)
            let c2 = yIntercept(m2, points[i].center)
            let x = (c2 - c1)/(m1 - m2)
            let y = m2*x + c2
            
            let x1 = points[i].center.x > points[i-1].center.x ? points[i].center.x : points[i-1].center.x
            let x2 = points[i].center.x < points[i-1].center.x ? points[i].center.x : points[i-1].center.x
            let y1 = points[i].center.y > points[i-1].center.y ? points[i].center.y : points[i-1].center.y
            let y2 = points[i].center.y < points[i-1].center.y ? points[i].center.y : points[i-1].center.y
            let x3 = prev.x > curr.x ? prev.x : curr.x
            let x4 = prev.x < curr.x ? prev.x : curr.x
            let y3 = prev.y > curr.y ? prev.y : curr.y
            let y4 = prev.y < curr.y ? prev.y : curr.y
            
            if x > x2 && x < x1 && y > y2 && y < y1 {
                if x > x4 && x < x3 && y > y4 && y < y3 {
                    return true
                }
            }
        }
        return false
    }
    
    private func gradient(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        return (p1.y - p2.y)/(p1.x - p2.x)
    }
    
    private func yIntercept(_ m: CGFloat, _ p: CGPoint) -> CGFloat {
        return -(m*p.x) + p.y
    }
    
}
