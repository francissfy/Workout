//
//  OnGoing.swift
//  Workout
//
//  Created by francis on 2019/3/1.
//  Copyright © 2019年 francis. All rights reserved.
//


//@Deprecated this file is no longer useful
import Foundation
import UIKit
class OnGoing:UIViewController{
    @IBAction func preBtn(_ sender: Any) {
        UIView.animate(withDuration: TimeInterval(0.4)) {
            self.yellow.transform = self.yellow.transform.translatedBy(x: 375, y: 0)
            self.red.transform = self.red.transform.translatedBy(x: 375, y: 0)
        }
    }
    @IBAction func nextBtn(_ sender: Any) {
        UIView.animate(withDuration: TimeInterval(0.4)) {
            self.yellow.transform = self.yellow.transform.translatedBy(x: -375, y: 0)
            self.red.transform = self.red.transform.translatedBy(x: -375, y: 0)
        }
    }
    @IBOutlet weak var yellow: UIImageView!
    @IBOutlet weak var red: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        red.transform = red.transform.translatedBy(x: 375, y: 0)
    }
    
}
