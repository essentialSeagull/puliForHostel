//
//  hostelInfoTableViewController.swift
//  puliForHostel
//
//  Created by viplab on 2020/5/31.
//  Copyright © 2020 viplab. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class hostelInfoTableViewController: UITableViewController {
    
    
    @IBOutlet var hostelPhotoView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var introduction: UILabel!
    @IBOutlet var headPicView:UIImageView!{
        didSet {
        headPicView.layer.cornerRadius = 50.0
        headPicView.clipsToBounds = true
        }
    }
    

    var array_context = [""]
    var imageURLstring: String?
    var headPicURLstring: String?

    var user = Auth.auth().currentUser
    var DB_ref: DatabaseReference = Database.database().reference()
    var SR_ref: StorageReference = Storage.storage().reference().child("photo")
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.DB_ref.child("Hotel_Info").child(user!.uid).observe( .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let Name = value?["Hotel_Name"] as! String
            let Intro = value?["Hotel_Introduction"] as! String
            let Where = value?[ "Hotel_Address"] as! String
            let Phone = value?["Hotel_Phone"] as! String
            
            self.nameLabel.text = Name
            self.placeLabel.text = Where
            self.phoneLabel.text = Phone
            self.introduction.text = Intro
            self.nameLabel.mutiLine()
            self.phoneLabel.mutiLine()
            self.placeLabel.mutiLine()
            self.introduction.mutiLine()

            self.tableView.reloadData()
            self.DB_ref.removeAllObservers()
        })
        
        PictureService.shared.downloadPic(PhotoView: hostelPhotoView)
        PictureService.shared.downloadHeadPic(headPicView: headPicView)
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
            

