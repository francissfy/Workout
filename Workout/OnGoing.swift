//
//  OnGoing.swift
//  Workout
//
//  Created by francis on 2019/3/1.
//  Copyright © 2019年 francis. All rights reserved.
//

import Foundation
import UIKit
class OnGoing:UIViewController{
    //
    @IBAction func backBtn(_ sender: Any) {
        UIView.animate(withDuration: TimeInterval.init(exactly: 1)!) {
            self.bottomView.transform = self.bottomView.transform.translatedBy(x: CGFloat(0), y: CGFloat(-215))
        }
        
        print(bottomView.frame.origin)
    }
    @IBAction func actionBtn(_ sender: Any) {
        UIView.animate(withDuration: TimeInterval.init(exactly: 1)!) {
            self.bottomView.transform = self.bottomView.transform.translatedBy(x: CGFloat(0), y: CGFloat(215))
        }
        print(bottomView.frame.origin)
    }
    @IBOutlet weak var bottomView: UIView!
    //
    var bottomSheetViewController:BottomSheetViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let wipeGesrecog = UIPanGestureRecognizer.init(target: self, action: #selector(handleGes))
        self.view.addGestureRecognizer(wipeGesrecog)
    }
    @IBAction func handleGes(_ sender: UIGestureRecognizer){
        print(sender.numberOfTouches)
        print(sender.location(in: bottomView))
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.destination)
        bottomSheetViewController = (segue.destination as! BottomSheetViewController)
    }
    
    
    @IBAction func panGesBottomSheetSlide(_ sender:UIGestureRecognizer){
        let currentSheetOrigin = bottomView.frame.origin
        let windowFrame = self.view.frame
        
        
        
        
        
        
        
    }
}
