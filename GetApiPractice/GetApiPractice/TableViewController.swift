//
//  TableViewController.swift
//  GetApiPractice
//
//  Created by 유준용 on 2021/06/16.
//

import UIKit

class TableViewController: UIViewController {

    
    @IBOutlet weak var bookMarkTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DataManager.shared.fetchBookMark()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib =  UINib(nibName: "BookMarkTableViewCell", bundle: .main)
        print("START")
        bookMarkTable.register(cellNib, forCellReuseIdentifier: "cell")
//        bookMarkTable.estimatedRowHeight = 80
//        bookMarkTable.rowHeight = UITableView.automaticDimension
        

    }
    


}
extension TableViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = URL(string: DataManager.shared.bookMarkList[indexPath.row].orgUrl!) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("@")

        })
        
        return UISwipeActionsConfiguration(actions:[deleteAction])
        
        

    }

    
}
extension TableViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("셀 개수: ",DataManager.shared.bookMarkList.count)
        return DataManager.shared.bookMarkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookMarkTableViewCell
        cell.setLabel(indexPath.row)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    
}
