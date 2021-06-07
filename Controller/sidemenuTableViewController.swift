//
//  sidemenuTableViewController.swift
//  puliForHostel
//
//  Created by viplab on 2020/5/26.
//  Copyright © 2020 viplab. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class sidemenuTableViewController: UITableViewController {
    
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var headPicView: UIImageView! {
        didSet {
        headPicView.layer.cornerRadius = 35
        headPicView.clipsToBounds = true
        }
    }
    
    var headPicURLstring: String?

    var user = Auth.auth().currentUser
    var DB_ref: DatabaseReference = Database.database().reference()
    var SR_ref: StorageReference = Storage.storage().reference().child("photo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = Auth.auth().currentUser {
            let userName = currentUser.displayName
            usernameLabel.text = userName
        }
       //沒有資料的cell欄位隱藏分隔線
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        PictureService.shared.downloadHeadPic(headPicView: headPicView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
               // Dispose of any resources that can be recreated.
    }
}

