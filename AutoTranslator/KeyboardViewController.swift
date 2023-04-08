//
//  KeyboardViewController.swift
//  AutoTranslator
//
//  Created by Asami Doi on 2023/04/09.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    func setupButton() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),
        ])
        
        self.button = UIButton(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
        self.button.setTitle("translate", for: .normal)
        self.button.setTitleColor(.gray, for: .normal)
        self.button.addTarget(self, action: #selector(sendRequestToOpenAI), for: .touchUpInside)
        //self.button.sizeToFit()
        //self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.backgroundColor = .white
        self.button.layer.cornerRadius = 8.0
        self.button.titleLabel?.font = UIFont.systemFont(ofSize: 24.0)
        
        stackView.addArrangedSubview(self.button)
        
        //self.button.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        //self.button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        /*
         NSLayoutConstraint.activate([
         self.button.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0),
         self.button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
         self.button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
         self.button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),
         ])
         */
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
    
    func prompt_natural(userText: String) -> String {
        return """
        {
            "model": "gpt-3.5-turbo",
            "messages": [
                {
                    "role": "system",
                    "content": "Translate the user text into English."
                },
                {
                    "role": "user",
                    "content": "\(userText)"
                }
            ]
        }
        """
    }
    
    @objc func sendRequestToOpenAI() {
        print("send a request to OpenAI API")
        let selectedText = textDocumentProxy.selectedText
        
        if selectedText == nil {
            return;
        }
        print("selected text: \(String(describing: selectedText))")
        
        let prompt = prompt_natural(userText: selectedText!)
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
