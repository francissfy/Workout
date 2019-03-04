//
//  BottomSheetViewController.swift
//  Workout
//
//  Created by francis on 2019/3/1.
//  Copyright © 2019年 francis. All rights reserved.
//

import Foundation
import UIKit
class BottomSheetViewController: UIViewController {
    //控件
    @IBOutlet weak var slider: UIImageView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var currentActionName: UILabel!
    @IBOutlet weak var actionNote: UITextView!
    @IBAction func achieveAction(_ sender: UIButton) {
    }
    @IBAction func preAction(_ sender: UIButton) {
    }
    @IBAction func SkipAction(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        print("bottomSheet View loaded")
        super.viewDidLoad()
        self.view.layer.cornerRadius = CGFloat(15)
        actionNote.layer.cornerRadius = CGFloat(8)
    }
}
