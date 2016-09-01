//
//  ViewController.swift
//  Project 4
//
//  Created by Emma Xu on 4/10/16.
//  Copyright © 2016 Emma Xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    //STUFF
    @IBOutlet weak var start: UIButton!
    @IBAction func hitstart(sender: UIButton) {
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        start.hidden = true
    }
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var ship: UIImageView!
    var asteroid: UIView!
    
    //OTHER STUFF
    lazy var timer: NSTimer = NSTimer(timeInterval: 1.5, target: self, selector: #selector(ViewController.timerFired(_:)), userInfo: nil, repeats: true)
    lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)
    var gravity: UIGravityBehavior!
    var collisions: UICollisionBehavior!
    var count = 0
    
    //ViewDidAppear
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //centering
        start.center.x = view.frame.width*0.5
        message.center.x = view.frame.width*0.5
        ship.center.x = view.frame.width*0.5
        
        //setup gravity, collisions
        collisions = UICollisionBehavior(items: [ship])
        collisions.translatesReferenceBoundsIntoBoundary = true
        collisions.collisionDelegate = self
        gravity = UIGravityBehavior()
        
        //add behaviors to animator
        animator.addBehavior(collisions)
        animator.addBehavior(gravity)
    }

    //timer creates asteroid each time
    func timerFired(timer: NSTimer) {
        
        let location = CGFloat(arc4random_uniform(400))
        asteroid = UIView(frame: CGRect(x:0, y:0, width:25, height:25))
        asteroid.center = CGPointMake(location, 25)
        asteroid.backgroundColor = UIColor.darkGrayColor()
        view.addSubview(asteroid)
        
        gravity.addItem(asteroid)
        collisions.addItem(asteroid)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        collisions.removeItem(asteroid)
        count += 1
        message.center.x = view.frame.width*0.5
        message.text = "Score: \(count)"
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        message.text = "Game Over! Score: \(count)"
        timer.invalidate()
        collisions.removeItem(asteroid)
        collisions.removeItem(ship)
    }
    
    //moves ship around
    @IBAction func panShip(sender: UIPanGestureRecognizer) {
        let panView = sender.view!
        let p = sender.translationInView(view)
        panView.center = CGPoint(x: panView.center.x+p.x, y: panView.center.y+p.y)
        sender.setTranslation(CGPointZero, inView: nil)
        animator.updateItemUsingCurrentState(ship)
    }
}

