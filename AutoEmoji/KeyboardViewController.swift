//
//  KeyboardViewController.swift
//  AutoEmoji
//
//  Created by Asami Doi on 2023/04/08.
//

import UIKit
import AudioToolbox

let BUTTON_DIAMETER = 330;

class KeyboardViewController: UIInputViewController {
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        NSLayoutConstraint(item: self.view!,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 0.0,
                           constant: 200).isActive = true
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 1.0, green: 0.80, blue: 0.88, alpha: 1)
        setupButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func setupButton() {
        //self.view.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.frame = CGRect(x: 0, y: 0, width: BUTTON_DIAMETER, height: BUTTON_DIAMETER)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(sendRequestToOpenAI), for: .touchDown)
        button.addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        button.addTarget(self, action: #selector(animateUp), for: [.touchUpOutside, .touchCancel, .touchDragExit, .touchUpInside])
        
        let icon = UIImage(named: "icon1_256.png")
        //let icon2 = UIImage(named: "icon2_256.png")
        
        //let icon3 = UIImage(named: "icon2_236.png")
        button.setImage(icon, for: .normal)
        //button.setImage(icon3, for: .highlighted)
        //button.setImage(icon3, for: .selected)
        
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = false
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
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 5,
                       options: [.curveEaseInOut],
                       animations: {
            button.transform = transform
        }, completion: nil)
    }
    
    @objc func orientationDidChange() {
        if UIDevice.current.orientation.isLandscape {
            print("横向き")
        } else if UIDevice.current.orientation.isPortrait {
            print("縦向き")
        }
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    @objc func sendRequestToOpenAI(sender: UIButton) {
        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        //let generator = UIImpactFeedbackGenerator(style: .light)
        // generator.impactOccurred()
        
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
