//
//  LaunchController.swift
//  InDot
//
//  Created by JAMES GOT GAME 07 on 30/6/17.
//  Copyright © 2017 Hamaste. All rights reserved.
//

import UIKit
import AVFoundation

class LaunchController: UIViewController {

    let beep =  Bundle.main.url(forResource: "beep", withExtension: "wav")!
    var soundPlayer = AVAudioPlayer()
    
    var r: CGFloat!
    var t: CGFloat!
    
    var background = UIColor.rgb(29,32,38)
    
    var prompt = UILabel()
    
    let dot = DotClass()
    let second_dot = DotClass()
    let indicator = IndicatorClass()
    
    var turn = 0
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = background
        
        r = 15
        t = view.frame.height/8
        
        prompt.frame = view.frame
        prompt.font = UIFont(name: "junegull", size: 250)
        prompt.adjustsFontSizeToFitWidth = true
        prompt.minimumScaleFactor = 0.5
        prompt.numberOfLines = 2
        prompt.textAlignment = .center
        prompt.text = "TAP TO\nSTOP"
        prompt.textColor = UIColor.lightGray
        prompt.alpha = 0.1
        view.addSubview(prompt)
        
        dot.setup(r: r, center: view.center, colour: UIColor.white)
        view.addSubview(dot)
        
        indicator.setup(p: dot.center, t: t, r: r, colour: UIColor.white)
        view.addSubview(indicator)
        timer = Timer.scheduledTimer(timeInterval: 1/360, target: self, selector: #selector(self.orbit), userInfo: nil, repeats: true)
        
        let end = UITapGestureRecognizer(target: self, action: #selector(self.endTurn))
        view.addGestureRecognizer(end)
    }

    func endTurn() {
        do {
            try soundPlayer = AVAudioPlayer(contentsOf: beep)
        } catch {
            print("error")
        }
        soundPlayer.prepareToPlay()
        soundPlayer.play()
        timer.invalidate()
        timer.invalidate()
        switch turn {
        case 0:
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(1/(t*4)), target: self, selector: #selector(self.extend), userInfo: nil, repeats: true)
            turn += 1
        case 1:
            second_dot.setup(r: r, center: indicator.getPoint(), colour: UIColor.white)
            second_dot.center = dot.center
            view.addSubview(second_dot)
            UIView.animate(withDuration: 0.4, animations: {
                self.second_dot.center = self.indicator.getPoint()
            }, completion: { (Bool) in
                sleep(2)
                self.performSegue(withIdentifier: "start", sender: self)
            })
            indicator.removeFromSuperview()
            connect(from: dot.center, to: second_dot.center, fill: UIColor.white.cgColor)
        default:
            break
        }
    }
    
    func orbit() { indicator.orbit() }
    
    func extend() { indicator.extend() }
    
    func connect(from start: CGPoint, to end:CGPoint, fill: CGColor) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = fill
        line.lineWidth = r*2
        line.lineJoin = kCALineJoinRound
        line.lineCap = "round"
        self.view.layer.addSublayer(line)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.4
        line.add(animation, forKey: "MyAnimation")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
