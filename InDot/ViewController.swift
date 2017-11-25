//
//  ViewController.swift
//  InDot
//
//  Created by JAMES GOT GAME 07 on 27/6/17.
//  Copyright © 2017 Hamaste. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let beep =  Bundle.main.url(forResource: "beep", withExtension: "wav")!
    let die =  Bundle.main.url(forResource: "explode", withExtension: "wav")!
    let win =  Bundle.main.url(forResource: "win", withExtension: "wav")!
    var soundPlayer = AVAudioPlayer()
    
    let background_music =  Bundle.main.url(forResource: "music", withExtension: "wav")!
    var musicPlayer = AVAudioPlayer()
    
    var r: CGFloat!
    var t: CGFloat!
    
    var background = UIColor.rgb(29,32,38)
    var player1_colour = UIColor.rgb(190,255,125)
    var player2_colour = UIColor.rgb(79,255,211)
    
    var winning_label = UILabel()
    
    var platform_height: CGFloat!
    
    var player1_platform = PlatformClass()
    var player2_platform = PlatformClass()
    
    var player1_dots = [DotClass]()
    var player1_lines = [CAShapeLayer]()
    
    var player2_dots = [DotClass]()
    var player2_lines = [CAShapeLayer]()
    
    var indicator = IndicatorClass()
    
    var turn = 0
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOf: background_music)
        } catch {
            print("error")
        }
        musicPlayer.prepareToPlay()
        musicPlayer.numberOfLoops = -1
        musicPlayer.play()
        
        view.backgroundColor = background
        
        r = 15
        t = view.frame.height/8
        
        winning_label.frame = view.frame
        winning_label.font = UIFont(name: "junegull", size: 150)
        winning_label.adjustsFontSizeToFitWidth = true
        winning_label.minimumScaleFactor = 0.5
        winning_label.numberOfLines = 2
        winning_label.textAlignment = .center
        view.addSubview(winning_label)
        
        platform_height = view.frame.height/5
        
        player1_platform.setup(f: CGRect(x: 0, y: view.frame.height - platform_height, width: view.frame.width, height: platform_height), colour: player1_colour)
        view.addSubview(player1_platform)
        
        player2_platform.setup(f: CGRect(x: 0, y: 0, width: view.frame.width, height: platform_height), colour: player2_colour)
        view.addSubview(player2_platform)
        
        instantiatePlayer(0)
        instantiatePlayer(1)
        
        indicator.setup(p: player1_dots[0].center, t: t, r: r, colour: player1_colour)
        view.addSubview(indicator)
        timer = Timer.scheduledTimer(timeInterval: 1/360, target: self, selector: #selector(self.orbit), userInfo: nil, repeats: true)
        turn += 1
        
        let end = UITapGestureRecognizer(target: self, action: #selector(self.endTurn))
        view.addGestureRecognizer(end)
    }
    
    func instantiatePlayer(_ player: Int) {
        switch player {
        case 0:
            let player1_dot = DotClass()
            player1_dot.setup(r: r, center: CGPoint(x: view.center.x, y: view.frame.height - platform_height/2), colour: player1_colour)
            player1_dots.append(player1_dot)
            view.addSubview(player1_dot)
        case 1:
            let player2_dot = DotClass()
            player2_dot.setup(r: r, center: CGPoint(x: view.center.x, y: platform_height/2), colour: player2_colour)
            player2_dots.append(player2_dot)
            view.addSubview(player2_dot)
        default:
            break
        }
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
        switch turn {
        case 0:
            if player1_dots.count > 1 {
                instantiate(1)
                indicator.removeFromSuperview()
                connect(from: player2_dots[player2_dots.count - 2].center, to: player2_dots[player2_dots.count - 1].center, fill: player2_colour.cgColor)
            }
            
            if indicator.getPoint().y > view.frame.height - platform_height {
                win(1)
            } else {
                indicator.setup(p: player1_dots[player1_dots.count - 1].center, t: t, r: r, colour: player1_colour)
                view.addSubview(indicator)
                timer = Timer.scheduledTimer(timeInterval: 1/360, target: self, selector: #selector(self.orbit), userInfo: nil, repeats: true)
                turn += 1
            }
        case 1:
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(1/(t*4)), target: self, selector: #selector(self.extend), userInfo: nil, repeats: true)
            turn += 1
        case 2:
            instantiate(0)
            indicator.removeFromSuperview()
            connect(from: player1_dots[player1_dots.count - 2].center, to: player1_dots[player1_dots.count - 1].center, fill: player1_colour.cgColor)
            
            if indicator.getPoint().y < platform_height {
                win(0)
            } else {
                indicator.setup(p: player2_dots[player2_dots.count - 1].center, t: t, r: r, colour: player2_colour)
                view.addSubview(indicator)
                timer = Timer.scheduledTimer(timeInterval: 1/360, target: self, selector: #selector(self.orbit), userInfo: nil, repeats: true)
                turn += 1
            }
        case 3:
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(1/(t*4)), target: self, selector: #selector(self.extend), userInfo: nil, repeats: true)
            turn = 0
        default:
            break
        }
    }
    
    func instantiate(_ player: Int) {
        let dot = DotClass()
        switch player {
        case 0:
            dot.setup(r: r, center: indicator.getPoint(), colour: player1_colour)
            player1_dots.append(dot)
            if dot.collision(points: player2_dots, prev: player1_dots[player1_dots.count - 2].center, curr: player1_dots[player1_dots.count - 1].center) {
                destruct(1)
            }
            dot.center = player1_dots[player1_dots.count-2].center
        case 1 :
            dot.setup(r: r, center: indicator.getPoint(), colour: player2_colour)
            player2_dots.append(dot)
            if dot.collision(points: player1_dots, prev: player2_dots[player2_dots.count - 2].center, curr: player2_dots[player2_dots.count - 1].center) {
                destruct(0)
            }
            dot.center = player2_dots[player2_dots.count-2].center
        default:
            break
        }
        view.addSubview(dot)
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            dot.center = self.indicator.getPoint()
        }, completion: nil)
    }
    
    func destruct(_ player: Int) {
        do {
            try soundPlayer = AVAudioPlayer(contentsOf: die)
        } catch {
            print("error")
        }
        soundPlayer.prepareToPlay()
        soundPlayer.play()
        timer.invalidate()
        view.frame.origin.x += 25
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.25, initialSpringVelocity: 0.25, options: [], animations: {
            self.view.frame.origin.x -= 25
        }, completion: nil)
        
        switch player {
        case 0:
            for _ in 0..<player1_dots.count {
                player1_dots[0].removeFromSuperview()
                player1_dots.removeFirst()
                instantiatePlayer(0)
            }
            for _ in 0..<player1_lines.count {
                player1_lines[0].removeFromSuperlayer()
                player1_lines.removeFirst()
            }
        case 1:
            for _ in 0..<player2_dots.count {
                player2_dots[0].removeFromSuperview()
                player2_dots.removeFirst()
                instantiatePlayer(1)
            }
            for _ in 0..<player2_lines.count {
                player2_lines[0].removeFromSuperlayer()
                player2_lines.removeFirst()
            }
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
        self.view.layer.insertSublayer(line, at: 0)
        if fill == player1_colour.cgColor {
            player1_lines.append(line)
        } else {
            player2_lines.append(line)
        }
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.4
        line.add(animation, forKey: "MyAnimation")
    }
    
    func win(_ player: Int) {
        do {
            try soundPlayer = AVAudioPlayer(contentsOf: win)
        } catch {
            print("error")
        }
        soundPlayer.prepareToPlay()
        soundPlayer.play()
        timer.invalidate()
        view.isUserInteractionEnabled = false
        switch player {
        case 0:
            winning_label.text = "GREEN\nWINS"
            winning_label.textColor = player1_colour
        case 1:
            winning_label.text = "BLUE\nWINS"
            winning_label.textColor = player2_colour
        default:
            break
        }
        winning_label.alpha = 0
        winning_label.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.winning_label.alpha = 1
            self.winning_label.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (Bool) in
            sleep(5)
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.winning_label.alpha = 0.5
                self.winning_label.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            }) { (Bool) in
                
            }
            self.winning_label.text = "SHAKE TO\nRESTART"
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.winning_label.alpha = 1
                self.winning_label.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (Bool) in
                
            }
        }
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if winning_label.text != "" {
                destruct(0)
                destruct(1)
                indicator.setup(p: player1_dots[0].center, t: t, r: r, colour: player1_colour)
                view.addSubview(indicator)
                timer = Timer.scheduledTimer(timeInterval: 1/360, target: self, selector: #selector(self.orbit), userInfo: nil, repeats: true)
                turn = 1
                view.isUserInteractionEnabled = true
                winning_label.text = ""
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
