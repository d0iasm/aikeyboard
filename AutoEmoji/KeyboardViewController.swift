//
//  KeyboardViewController.swift
//  AutoEmoji
//
//  Created by Asami Doi on 2023/04/08.
//

import UIKit

let OPENAI_URL = "https://api.openai.com/v1/completions"
let OPENAI_API_KEY = ""

class KeyboardViewController: UIInputViewController, UITextFieldDelegate {
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        /*
        let heightConstraint = NSLayoutConstraint(item:self.view as Any,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 0.0,
                                                  constant: 200.0)
        view.addConstraint(heightConstraint)
         */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
    }
    
    func setupButtons() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),
        ])
        
        for i in 0..<2 {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 8.0
            stackView.addArrangedSubview(rowStackView)
            
            for j in 0..<3 {
                let button = UIButton(type: .system)
                button.setTitle("\(i*3+j+1)", for: .normal)
                button.setTitleColor(.gray, for: .normal)
                button.addTarget(self, action: #selector(sendRequestToOpenAI), for: .touchUpInside)
                button.backgroundColor = .white
                button.layer.cornerRadius = 8.0
                button.titleLabel?.font = UIFont.systemFont(ofSize: 24.0)
                rowStackView.addArrangedSubview(button)
            }
        }
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
    
    @objc func sendRequestToOpenAI() {
        print("send a request to OpenAI API")
        let selectedText = textDocumentProxy.selectedText
        
        if selectedText == nil {
            return;
        }
        
        print("selected text: \(String(describing: selectedText))")
        
        let data: [String: Any] =
        ["model": "text-davinci-003",
         //["model": "gpt-3.5-turbo",
         "prompt": #"""
Replace the following the sentence or word with the one with nice Emojis. Please follow the 4 rules below:

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
                    textDocumentProxy.insertText(text.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    print("Failed to parse choices or text from the response data.")
                }
            }
        }
    }

}
