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
    
    @IBOutlet weak var orgUrlLabel: UILabel!
    @IBOutlet weak var ogImageView: UIImageView!
    
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
                        self.ogImageView.image = image
                    }
                }
            case .failure(_):
                return
            }
        }
    }
    
    func setLabel(_ indexPath: Int){
        shortenUrlLabel.text = DataManager.shared.bookMarkList[indexPath].shortenUrl
        orgUrlLabel.text = DataManager.shared.bookMarkList[indexPath].orgUrl
        orgUrlLabel.textColor = .systemGray
        
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
