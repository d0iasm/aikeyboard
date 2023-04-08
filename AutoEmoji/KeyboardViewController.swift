//
//  KeyboardViewController.swift
//  AutoEmoji
//
//  Created by Asami Doi on 2023/04/08.
//

import UIKit

class KeyboardViewController: UIInputViewController, UITextFieldDelegate {
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
                button.addTarget(self, action: #selector(sendRequestToOpenAI(sender:)), for: .touchUpInside)
                button.backgroundColor = .white
                button.layer.cornerRadius = 8.0
                button.titleLabel?.font = UIFont.systemFont(ofSize: 24.0)
                rowStackView.addArrangedSubview(button)
            }
        }
    }
    
    func getPromptFromTitle(title: String, userText: String) -> String {
        if title == "1" {
            return prompt_emoji(userText: userText)
        } else if title == "2" {
            return prompt_lovely_emoji(userText: userText)
        } else if title == "3" {
            return prompt_natural(userText: userText)
        } else if title == "4" {
            return prompt_s1(userText: userText)
        } else if title == "5" {
            return prompt_high_tension(userText: userText)
        }
        return ""
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
    
    /*
     @objc func sendRequestToOpenAI(sender: UIButton) {
     print("send a request to OpenAI API")
     let selectedText = textDocumentProxy.selectedText
     
     if selectedText == nil {
     return;
     }
     print("selected text: \(String(describing: selectedText))")
     
     var prompt = ""
     if let title = sender.title(for: .normal) {
     prompt = getPromptFromTitle(title: title)
     }
     if prompt == "" {
     return;
     }
     
     let data: [String: Any] =
     ["model": "text-davinci-003",
     "prompt": prompt + selectedText!,
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
     print("response data: \(dataString)")
     
     if let dictionary = convertToDictionary(from: dataString),
     let choices = dictionary["choices"] as? [[String: Any]],
     let text = choices.first?["text"] as? String {
     print("Text: \(text)")
     textDocumentProxy.insertText(text.trimmingCharacters(in: .whitespacesAndNewlines))
     } else {
     print("failed to parse response data")
     }
     }
     }
     }
     */
    
    @objc func sendRequestToOpenAI(sender: UIButton) {
        print("send a request to OpenAI API")
        let selectedText = textDocumentProxy.selectedText
        
        if selectedText == nil {
            return;
        }
        print("selected text: \(String(describing: selectedText))")
        
        var prompt = ""
        if let title = sender.title(for: .normal) {
            prompt = getPromptFromTitle(title: title, userText: selectedText!)
        }
        if prompt == "" {
            return;
        }
        
        print("data: \(prompt)")
        
        let url = URL(string: OPENAI_URL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 5.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + OPENAI_API_KEY, forHTTPHeaderField: "Authorization")
        request.httpBody = prompt.data(using: .utf8)
        
        print("request is sending \(String(describing: request))")
        Task {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("response data: \(dataString)")
                
                if let dictionary = convertToDictionary(from: dataString),
                   let choices = dictionary["choices"] as? [[String: Any]],
                   let result = choices.first?["message"] as? [String: Any],
                   let text = result["content"] as? String {
                    print("Text: \(text)")
                    textDocumentProxy.insertText(text.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    print("failed to parse response data")
                }
            }
        }
    }
}
