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
        
        let button = UIButton(type: .system)
        button.setTitle("emoji", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(sendRequestToOpenAI), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24.0)
        stackView.addArrangedSubview(button)
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
    func prompt_emoji(userText: String) -> String {
        return """
    {
        "model": "gpt-3.5-turbo",
        "messages": [
            {
                "role": "system",
                "content": "Insert suitable emoji(s) into the end and middle of user's sentence, and replace all periods and 句点 with suitable emoji(s). Do not modify the user's text and keep the original text. Do not add a white space between emojis."
            },
            {
                "role": "user",
                "content": "\(userText)"
            }
        ]
    }
    """
    }*/
    
    func prompt_emoji(userText: String) -> String {
        return """
    {
        "model": "gpt-3.5-turbo",
        "messages": [
            {
                "role": "system",
                "content": "文面を元にユーザーの文章に適切な絵文字を挿入してください。文末に句読点がある場合は必ず置き換えてください。ユーザーの文章は絶対に書き換えないでください。"
            },
            {
                "role": "user",
                "content": "\(userText)"
            }
        ]
    }
    """
    }
    
    @objc func sendRequestToOpenAI(sender: UIButton) {
        print("send a request to OpenAI API")
        let selectedText = textDocumentProxy.selectedText
        
        if selectedText == nil {
            return;
        }
        print("selected text: \(String(describing: selectedText))")
        
        let prompt = prompt_emoji(userText: selectedText!)
        print("data: \(prompt)")
        
        let url = URL(string: OPENAI_URL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 15.0
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
