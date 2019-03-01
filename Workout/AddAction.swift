//
//  AddAction.swift
//  Workout
//
//  Created by francis on 2019/2/25.
//  Copyright © 2019年 francis. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class AddAction:UIViewController,UITextViewDelegate,UITextFieldDelegate{
    //控件
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func done(_ sender: Any) {
        saveAction(action: newAction)
    }
    @IBOutlet weak var actionName: UITextField!
    @IBOutlet weak var actionNote: UITextView!
    //变量
    var newAction:Action = Action.init(name: "Default Name", note: "Default Note")
    override func viewDidLoad() {
        super.viewDidLoad()
        actionNote.delegate = self
        actionName.delegate = self
        actionNote.layer.cornerRadius = CGFloat(8)
    }
    //textView delegate
    func textViewDidEndEditing(_ textView: UITextView) {
        newAction.note = textView.text
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if(textField.text == ""){
            let nameEmptyAlert = UIAlertController.init(title: "Name Empty", message: "Please enter action name", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            nameEmptyAlert.addAction(cancel)
            self.present(nameEmptyAlert, animated: true, completion: nil)
        }else{
            newAction.name = textField.text!
        }
    }
    func saveAction(action:Action){
        let savingAlert = UIAlertController.init(title: "Saving", message: nil, preferredStyle: UIAlertController.Style.alert)
        let persistentCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator
        DispatchQueue.global().async {
            let ctx = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
            ctx.persistentStoreCoordinator = persistentCoordinator
            let actionEntityDescription = NSEntityDescription.entity(forEntityName: "Actions", in: ctx)!
            let actionMO = NSManagedObject.init(entity: actionEntityDescription, insertInto: ctx) as! Actions
            actionMO.name = action.name
            actionMO.note = action.note
            ctx.performAndWait {
                do{
                    DispatchQueue.main.async {
                        self.present(savingAlert, animated: true, completion: nil)
                    }
                    try ctx.save()
                    DispatchQueue.main.async {
                        savingAlert.dismiss(animated: true, completion: {()->Void in
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                }catch{fatalError(error.localizedDescription)}
            }
        }
    }
}
