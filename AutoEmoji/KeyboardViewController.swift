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
        let selectedText = textDocumentProxy.selectedText
        
        let OPENAI_URL = "https://api.openai.com/v1/completions"
        let OPENAI_API_KEY = ""
        
        if selectedText == nil {
            return;
        }
        
        print("selectedText \(String(describing: selectedText))")
        
        let data: [String: Any] =
        ["model": "text-davinci-003",
         "prompt": "Find a best emoji from the sentence: " + selectedText!,
         "temperature": "0.3",
         "max_tokens": "100",
         "top_p": "1.0",
         "frequency_penalty": "0.0",
         "presence_penalty": "0.0",
        ]
        
        let url = URL(string: OPENAI_URL)
        //let url = URL(string: "https://example.com")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 5.0
        request.setValue("Content-Type", forHTTPHeaderField: "application/json")
        request.setValue("Authorization", forHTTPHeaderField: OPENAI_API_KEY)
        request.httpBody = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        print("request is sending \(String(describing: request))")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("dataTask is finished")
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
        }
        task.resume()
        
        /*
         Task {
         let (data, response) = try await URLSession.shared.data(for: request)
         
         let body = response.body
         
         print("data \(data)")
         print("response \(response)")
         }
         */
    }
    
    override func viewDidLoad() {
        let keyboardType = textDocumentProxy.keyboardType
        print("viewDidLoad \(String(describing: keyboardType))")
        
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
