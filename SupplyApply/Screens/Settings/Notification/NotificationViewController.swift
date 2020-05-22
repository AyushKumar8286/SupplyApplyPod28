//
//  NotificationViewController.swift
//  SupplyApply
//
//  Created by Mac3 on 16/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

class NotificationViewController: CustomViewController {

    //MARK:- VARIABLE
    var parentVC : AnimatedAppTabBar!
    var nameArray = [String]()
    var timeArray = [String]()
    
    //MARK:- IBOUTLET
    @IBOutlet weak var viewNotificationTable: UITableView!
    
    //MARK:- VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    //MARK:- PRIVATE METHODS
    
    private func setUpView() {
    
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        
        for i in 0..<10 {
            nameArray.append(String(i))
            timeArray.append(String(i))
        }
        
//        let notificationdetail = DBManager.fetchNotificationDetailToDB()
//        for i in 0..<notificationdetail.0.count {
//            nameArray.append(notificationdetail.0[i])
//            timeArray.append(notificationdetail.1[i])
//        }
        viewNotificationTable.register(UINib(nibName: "NoticationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NoticationTableViewCell")
        viewNotificationTable.delegate = self
        viewNotificationTable.dataSource = self
        viewNotificationTable.reloadData()
    }
}

//MARK:- TABLEVIEW DELEGATE AND DATA SOURCE

extension NotificationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticationTableViewCell") as! NoticationTableViewCell
        addShadowToView(view: cell.viewContent)
        cell.selectionStyle = .none
        cell.lblDescription.text = (nameArray[indexPath.row]) + (timeArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
