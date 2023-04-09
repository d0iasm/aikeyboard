//
//  KeyboardViewController.swift
//  AutoEmoji
//
//  Created by Asami Doi on 2023/04/08.
//

import UIKit

let BUTTON_DIAMETER = 300;

class KeyboardViewController: UIInputViewController {
    override func updateViewConstraints() {
        print("update view constraints===============================")
        super.updateViewConstraints()
        
        NSLayoutConstraint(item: self.view!,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 0.0,
                           constant: 150).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        
        self.view.layoutIfNeeded()
    }
    
    func setupButton() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.frame = CGRect(x: 0, y: 0, width: BUTTON_DIAMETER, height: BUTTON_DIAMETER)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(sendRequestToOpenAI), for: .touchUpInside)
        let icon = UIImage(named: "icon1_256.png")
        button.setImage(icon, for: .normal)
        //button.setImage(icon, for: .highlighted)
        //button.setImage(icon, for: .selected)
        
        //button.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: button.center.y)
        
        //button.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        
        /*
        NSLayoutConstraint.activate([
            //button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        let constraint = button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        constraint.constant = UIScreen.main.bounds.width / 2
        self.view.layoutIfNeeded()
         */
        
        /*
         NSLayoutConstraint.activate([
         button.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0),
         button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
         button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10.0),
         button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10.0),
         ])
         */
        //button.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.size.height / 2)
        //button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        //stackView.addArrangedSubview(button)
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
    
    func prompt_emoji(userText: String) -> String {
        return """
    {
        "model": "gpt-3.5-turbo",
        "messages": [
            {
                "role": "system",
                "content": "文面を元にユーザーの文章に適切な絵文字を挿入してください。文末に「。」の句読点がある場合は必ず絵文字または「！」に置き換えてください。ユーザーの文章は絶対に書き換えないでください。"
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
