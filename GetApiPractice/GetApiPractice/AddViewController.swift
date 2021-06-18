//
//  ViewController.swift
//  GetApiPractice
//
//  Created by 유준용 on 2021/06/14.
//

import UIKit
import OpenGraph

class AddViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var orgView: UIView!
    
    @IBOutlet weak var shortenUrlLabel: UILabel!
    @IBOutlet weak var orgUrlLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    
    
    @IBAction func getButton(_ sender: Any) {
        let query = textField.text!
        requestGet(query: query)
        getOgImage(urlString: query)
    }
    
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
        if let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ,let url = URL(string: encodedUrl){
            var image : UIImage?
            OpenGraph.fetch(url: url) { result in
                switch result {
                case .success(let og):
                    print("og get success")
                    if let ogImage = og[.image]{
                        let imageUrl = URL(string: ogImage)
                        DispatchQueue.global().async {
                            let data = try? Data(contentsOf: imageUrl!)
                            DispatchQueue.main.async {
                                image = UIImage(data: data!)
                                self.imageView.image = image
                            }
                        }
                    }
                    
                case .failure(_):
                    return
                }
            }
        }
    }
    
    func requestGet(query : String){
        let clientID = "riSTh9tti8xFddxQsnK_"
        let clientSecret = "yvi1OHlNhg"
        let apiUrl : String = "https://openapi.naver.com/v1/util/shorturl.json?url=\(query)"
        print("쿼리: ", query)
        
        if let encodedUrl = apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ,let queryUrl = URL(string: encodedUrl) {
            print("get apiUrl")
            var request = URLRequest(url: queryUrl)
            request.httpMethod = "GET"
            request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
            request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
                
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                guard let data = data else {return}
                print("URLSession.shared")
                self.jsonParse(data : data)
            }.resume()
        }
    
    }



    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)

   }


    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        buttonView.gradientButton("Get", startColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), endColor: #colorLiteral(red: 0.2256177068, green: 0.3264122009, blue: 1, alpha: 1))
        orgView.layer.borderWidth = 2
        orgView.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)

    }
    
    
    func saveUrl(orgUrl : String, shortenUrl : String){
        shortenUrlLabel.text = shortenUrl
        orgUrlLabel.text = orgUrl
        DataManager.shared.addBookMark(orgUrl, shortenUrl: shortenUrl)
        print("in saveURL function")
        print(shortenUrl)
        print(orgUrl)
    }
}
extension UIViewController : UITextFieldDelegate {
    
}
