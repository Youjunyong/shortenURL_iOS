//
//  BookMarkTableViewCell.swift
//  GetApiPractice
//
//  Created by 유준용 on 2021/06/17.
//
import OpenGraph
import UIKit

class BookMarkTableViewCell: UITableViewCell {

    @IBOutlet weak var shortenUrlLabel: UILabel!
    
    
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var orgUrlLabel: UILabel!
    @IBOutlet weak var ogImageView: UIImageView!
    
    
    
    @IBAction func copyButtonClick(_ sender: UIButton) {
        let contentView = sender.superview?.superview
        let cell = contentView?.superview as! UITableViewCell
        let tableView = cell.superview as! UITableView
        let index = tableView.indexPath(for: cell)?.row ?? 1
        let shortenUrl = DataManager.shared.bookMarkList[index].shortenUrl
        UIPasteboard.general.string = shortenUrl
        
        
        let alert = UIAlertController(title: "성공", message: "복사 되었습니다.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
        alert.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        // 얼럿 적용시킬수 있는 다른 방법이 있는지?
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
                                self.ogImageView.image = image
                            }
                        }
                    }
                    
                case .failure(_):
                    return
                }
            }
        }
    }

    
    func setLabel(_ indexPath: Int){
        shortenUrlLabel.text = DataManager.shared.bookMarkList[indexPath].shortenUrl
        orgUrlLabel.text = DataManager.shared.bookMarkList[indexPath].orgUrl
        orgUrlLabel.textColor = .systemGray
        
        testView.gradientButton("Copy", startColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), endColor: #colorLiteral(red: 0.2256177068, green: 0.3264122009, blue: 1, alpha: 1))
        
       
        let orgUrl = DataManager.shared.bookMarkList[indexPath].orgUrl
        getOgImage(urlString: orgUrl!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DataManager.shared.fetchBookMark()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension UIView{

    func gradientButton(_ buttonText:String, startColor:UIColor, endColor:UIColor) {

        let button:UIButton = UIButton(frame: self.bounds)
        button.setTitle(buttonText, for: .normal)

        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
        self.mask = button

        button.layer.cornerRadius =  button.frame.size.height / 2
        button.layer.borderWidth = 5.0
    }
    
}

