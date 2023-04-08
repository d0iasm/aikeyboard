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
    
    func convertToDictionary(from jsonString: String) -> [String: Any]? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print("Error converting to dictionary: \(error.localizedDescription)")
            return nil
        }
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
        //["model": "text-davinci-003",
        ["model": "gpt-3.5-turbo",
         "prompt": #"""
Replace the following the sentence with the one with nice Emojis. Please follow the 4 rules below:

1) Put emoji(s) at the end of each sentence
2) Always replace 。 with some emojis
3) Do not delete any words from the original sentence
4) Do not insert additional new lines

Sentence:
"""# + selectedText!,
         //"temperature": 0.3,
         //"max_tokens": 100,
         //"top_p": "1.0",
         //"frequency_penalty": "0.0",
         //"presence_penalty": "0.0",
        ]
        
        print("prompt: \(String(describing: data["prompt"]))")
        
        let url = URL(string: OPENAI_URL)
        //let url = URL(string: "https://example.com")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 5.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + OPENAI_API_KEY, forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        print("request is sending \(String(describing: request))")
        
        Task {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("Response data string: \(dataString)")
                
                if let dictionary = convertToDictionary(from: dataString),
                   let choices = dictionary["choices"] as? [[String: Any]],
                   let text = choices.first?["text"] as? String {
                    print("Text: \(text)")
                    textDocumentProxy.insertText(text)
                } else {
                    print("Failed to parse choices or text from the response data.")
                }
            }
        }
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
