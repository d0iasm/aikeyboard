//
//  KeyboardViewController.swift
//  AutoEmoji
//
//  Created by Asami Doi on 2023/04/08.
//

import UIKit

extension UITextField {
    func addInputAccessoryView(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

class KeyboardViewController: UIInputViewController, UITextFieldDelegate {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var testButton: UIButton!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet weak var textField: UITextField!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    func setupToolBar(){
        let dragButton = UIButton()
        dragButton.backgroundColor = .red
        dragButton.frame = CGRect(x: 0, y: 0, width: 80, height: 4)
        dragButton.contentMode = .scaleAspectFit
        dragButton.setBackgroundImage(UIImage(named: "drag"), for: .normal)
        
        
        // So here we do some stuff with the toolBar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        toolBar.barTintColor = .clear
        toolBar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        toolBar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
        toolBar.backgroundColor = .white
        toolBar.isOpaque = false
        
        //The flexible space helps to arrange things inside the toolBar
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let ourButton = UIBarButtonItem.init(customView: dragButton)
        
        // we added 2 flexible spaces to keep are button at the center of the toolBar
        toolBar.setItems([flexibleSpace, ourButton, flexibleSpace], animated: true)
        // and we add our toolBar with our UIButton above our someTextField keyboard)
        self.textField.inputAccessoryView = toolBar
    }
    
    @objc func tapDone() {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.textField = UITextField()
        //self.textField.delegate = self
        //self.textField.addInputAccessoryView(title: "Done", target: self, selector: #selector(tapDone))
        
        /*
         self.toolBar = UIToolbar()
         self.toolBar.barStyle = .default
         self.toolBar.isTranslucent = true
         self.toolBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
         let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
         let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
         self.toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
         
         self.toolBar.isUserInteractionEnabled = true
         self.toolBar.sizeToFit()
         
         self.view.addSubview(self.toolBar)
         self.toolBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
         self.toolBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
         */
        //setupToolBar()
        
        self.toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        self.toolBar.sizeToFit()
        let testButton = UIBarButtonItem(title: "insert emoji", style:.plain, target: nil, action: nil)
        //self.view.addSubview(testButton)
        //testButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        //testButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.toolBar.setItems([testButton], animated: false)
        self.view.addSubview(self.toolBar)
        
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
