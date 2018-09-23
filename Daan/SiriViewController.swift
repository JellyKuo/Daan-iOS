//
//  SiriViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2018/9/20.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import UIKit
import Intents
import IntentsUI

@available(iOS 12.0, *)
class SiriViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSiriButton()
        // Do any additional setup after loading the view.
    }
    
    func addSiriButton() {
        let button = INUIAddVoiceShortcutButton(style: .blackOutline)
        let intent = NextClassIntent()
        intent.suggestedInvocationPhrase = "Next class"
        button.shortcut = INShortcut(intent: intent)
        button.delegate = self
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

@available(iOS 12.0, *)
extension SiriViewController :INUIAddVoiceShortcutViewControllerDelegate{
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let error = error as NSError? {
            print("[Add Shortcut Controller] Error adding voice shortcut \(error)")
        }
        print("[Add Shortcut Controller] Finished")
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        print("[Add Shortcut Controller] Cancel")
        controller.dismiss(animated: true, completion: nil)
    }
}

@available(iOS 12.0, *)
extension SiriViewController :INUIAddVoiceShortcutButtonDelegate{
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        print("[Add Shortcut Button] Present Add")
        addVoiceShortcutViewController.delegate = self
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        print("[Add Shortcut Controller] Present Edit")
        editVoiceShortcutViewController.delegate = self
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
}


@available(iOS 12.0, *)
extension SiriViewController :INUIEditVoiceShortcutViewControllerDelegate{
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        print("[Edit Shortcut Controller] Update")
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        print("[Edit Shortcut Controller] Delete")
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        print("[Edit Shortcut Controller] Cancel")
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
