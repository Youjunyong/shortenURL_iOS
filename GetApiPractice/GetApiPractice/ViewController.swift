//
//  ViewController.swift
//  GetApiPractice
//
//  Created by 유준용 on 2021/06/14.
//

import UIKit

class ViewController: UIViewController {

    
    
    func requestGet(query : String) {
        let clientID = "riSTh9tti8xFddxQsnK_"
        let clientSecret = "yvi1OHlNhg"
        let apiUrl : String = "https://openapi.naver.com/v1/util/shorturl.json?url=\(query)"
        let queryURL: URL = URL(string: apiUrl)!
        var request = URLRequest(url: queryURL)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return
                    }

                    guard let data = String(bytes: data!, encoding: .utf8) else {
                        return
                    }

                    print("data: \(data)")
                }.resume()
        
    }
    @IBOutlet weak var textField: UITextField!
    @IBAction func btn(_ sender: Any) {
        let query = textField.text
        requestGet(query: query!)
    }
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.placeholder="원본 URL을 입력하세요."
        textField.becomeFirstResponder()

//        requestGet(query: "https://naver.com")

  

        
        
    }
}
extension UIViewController : UITextFieldDelegate {
    
}

