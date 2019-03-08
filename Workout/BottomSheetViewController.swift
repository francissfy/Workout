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
    @IBOutlet weak var freqLeft: UILabel!
    @IBOutlet weak var achieveBtn: UIButton!
    @IBOutlet weak var preBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBAction func achieveAction(_ sender: UIButton) {
        achieve()
    }
    @IBAction func preAction(_ sender: UIButton) {
        pre()
    }
    @IBAction func SkipAction(_ sender: UIButton) {
        skip()
    }
    var actionSeq:[SpecifiedAction] = []
    var currentExecuting:Int = -1
    var finish = {()->Void in
        print("Finished!")
    }
    override func viewDidLoad() {
        print("bottomSheet View loaded")
        super.viewDidLoad()
        self.view.layer.cornerRadius = CGFloat(15)
        actionNote.layer.cornerRadius = CGFloat(8)
        if(currentExecuting == -1){}
    }
    func start(actionToStart:Int){
        let specAction = actionSeq[actionToStart]
        currentActionName.text = specAction.action.name
        freqLeft.text = "\(specAction.group)X\(specAction.num)"
        actionNote.text = specAction.action.note
        achieveBtn.isEnabled = true
        skipBtn.isEnabled = true
        currentExecuting = actionToStart
        if(actionToStart == actionSeq.count-1){
            preBtn.isEnabled = true
        }else if(actionToStart == 0){
            preBtn.isEnabled = false
        }else{
            preBtn.isEnabled = true
        }
    }
    func finishTraining(){
        finish()
        endTraining()
    }
    func achieve(){
        if(actionSeq[currentExecuting].group == 1){
            skip()
        }else{
            actionSeq[currentExecuting].group -= 1
            freqLeft.text = "\(actionSeq[currentExecuting].group)X\(actionSeq[currentExecuting].num)"
        }
    }
    func skip(){
        if(currentExecuting == actionSeq.count-1){
            finishTraining()
        }else{
            currentExecuting += 1
            start(actionToStart: currentExecuting)
        }
    }
    func pre(){
        currentExecuting -= 1
        start(actionToStart: currentExecuting)
    }
    func endTraining(){
        currentActionName.text = "No Executing"
        freqLeft.text = "- X --"
        actionNote.text = ""
        achieveBtn.isEnabled = false
        preBtn.isEnabled = false
        skipBtn.isEnabled = false
    }
    
}
