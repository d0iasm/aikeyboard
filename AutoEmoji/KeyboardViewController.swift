//
//  KeyboardViewController.swift
//  AutoEmoji
//
//  Created by Asami Doi on 2023/04/08.
//

import UIKit

class KeyboardViewController: UIInputViewController, UITextFieldDelegate {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var toolBar: UIToolbar!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    func setupToolBar(){
        self.toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        self.toolBar.sizeToFit()
        let testButton = UIBarButtonItem(title: "insert emoji", style:.plain, target: nil, action: #selector(sendRequest))
        self.toolBar.setItems([testButton], animated: false)
        self.view.addSubview(self.toolBar)
    }
    
    @objc func sendRequest() {
        print("sendRequest!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToolBar()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        //self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        print("textWillChange \(String(describing: textInput))")
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        print("textDidChange \(String(describing: textInput))")
        let selectedText = textDocumentProxy.selectedText
        print("textDidChange \(String(describing: selectedText))")
        //textDocumentProxy.insertText("Hello world.")
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
}
