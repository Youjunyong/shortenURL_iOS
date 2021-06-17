//
//  CustomCell.swift
//  GetApiPractice
//
//  Created by 유준용 on 2021/06/17.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet var orgUrlLabel: UILabel!
    @IBOutlet var shortenUrlLabel: UILabel!
    @IBOutlet var ogImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    
    func setLabelText(_ indexPath: Int){
        orgUrlLabel.text = DataManager.shared.bookMarkList[indexPath].orgUrl
        shortenUrlLabel.text = DataManager.shared.bookMarkList[indexPath].shortenUrl
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
