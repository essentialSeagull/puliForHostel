//
//  detailTableViewController.swift
//  puliForHostel
//
//  Created by viplab on 2020/5/27.
//  Copyright © 2020 viplab. All rights reserved.
//

import UIKit
import Firebase

class detailTableViewController: UITableViewController {
    var user = Auth.auth().currentUser
    var hostelName =  Auth.auth().currentUser?.displayName
    var DB_ref: DatabaseReference = Database.database().reference()
    
    @IBOutlet var nameL: UILabel!
    @IBOutlet var timeInL: UILabel!
 //   @IBOutlet var roomTypeL:UILabel!
    @IBOutlet var PPLL: UILabel!
    @IBOutlet var phoneL: UILabel!
    @IBOutlet var doneL: UILabel!
    @IBOutlet var EmailL: UILabel!
    @IBOutlet var timeOutL: UILabel!
    
    
    var orderName: String?
    var orderDateIn: String?
    var orderDateOut: String?
    var orderRoomtype: String?
    var orderppl: String?
    var orderphone: String?
    var orderDone: String?
    var orderEmail: String?
    var orderid: String?
    
    
    
    let dataArray = ["單人房","雙人房","四人房"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameL.text = orderName
        timeInL.text = orderDateIn
        timeOutL.text = orderDateOut
        PPLL.text = orderppl
        phoneL.text = orderphone
        doneL.text = orderDone
        EmailL.text = orderEmail
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func changeDone(){
        if orderDone == "已完成" {
            alreadyDone()
            
        } else{
            self.DB_ref.child("CheckOrder").child(hostelName!).child(orderid!).child("doneOrNot").setValue("已完成")
                done()
            doneL.text = "已完成"
            }
    }
    @IBAction func checkIN(_ sender: Any) {
        let controller = UIAlertController(title: "是否確認Check-In", message: "check-In請按確定～", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default){(void) in
            self.changeDone()
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}

 
extension detailTableViewController {
    
    func done(){
        let controller = UIAlertController(title: "已完成Check-In囉！", message: nil, preferredStyle: .alert)
        let okaction = UIAlertAction(title:"確定", style: .default, handler: nil)
        controller.addAction(okaction)
        present(controller, animated: true, completion: nil)
    }
    func alreadyDone(){
        let controller = UIAlertController(title: "已經Check-In過囉！", message: "不用重複checkIn。", preferredStyle: .alert)
        let okaction = UIAlertAction(title:"確定", style: .default, handler: nil)
        controller.addAction(okaction)
        present(controller, animated: true, completion: nil)
    }
}
