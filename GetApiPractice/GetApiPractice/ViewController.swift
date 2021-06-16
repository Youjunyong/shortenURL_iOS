//
//  ViewController.swift
//  GetApiPractice
//
//  Created by 유준용 on 2021/06/14.
//

import UIKit
import OpenGraph

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func Button(_ sender: Any) {
        let query  = textField.text!
        requestGet(query: query)
        getOgImage(urlString: query)
    }
 
    @IBOutlet weak var shortenUrlLabel: UILabel!
    @IBOutlet weak var orgUrlLabel: UILabel!


    func jsonParse(data : Data) {
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
            if let result = json["result"] as? [String: Any] {
                guard let orgUrl = result["orgUrl"] as? String else {return }
                guard let shortenUrl = result["url"] as? String else { return}
                DispatchQueue.main.async{
                    self.saveUrl(orgUrl: orgUrl, shortenUrl: shortenUrl)
                }
            }
        }
    }
    
    func getOgImage(urlString : String){
        let url : URL = URL(string: urlString)!
        var image : UIImage?
        OpenGraph.fetch(url: url) { result in
            switch result {
            case .success(let og):
                print(og[.image]!)
                let imageUrl = URL(string: og[.image]!)
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageUrl!)
                    DispatchQueue.main.async {
                        image = UIImage(data: data!)
                        self.imageView.image = image
                    }

                }
            case .failure(_):
                return
            }
        }
    }
    
    func requestGet(query : String){
        let clientID = "riSTh9tti8xFddxQsnK_"
        let clientSecret = "yvi1OHlNhg"
        let apiUrl : String = "https://openapi.naver.com/v1/util/shorturl.json?url=\(query)"
        let queryURL: URL = URL(string: apiUrl)!
        var request = URLRequest(url: queryURL)
        
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
            
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data else {return}
            self.jsonParse(data : data)
        }.resume()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
    }
    
    
    func saveUrl(orgUrl : String, shortenUrl : String){
        shortenUrlLabel.text = shortenUrl
        orgUrlLabel.text = orgUrl
        print("in saveURL function")
        print(shortenUrl)
        print(orgUrl)
    }
}
extension UIViewController : UITextFieldDelegate {
    
}

