//
//  mainOrderViewController.swift
//  puliForHostel
//
//  Created by viplab on 2020/5/26.
//  Copyright © 2020 viplab. All rights reserved.
//

import UIKit
import Firebase
import SideMenu

class mainOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var isLoadingOrder = false
    @IBOutlet var tableView: UITableView!
    
    var refreshControl:UIRefreshControl!
    var DB_ref : DatabaseReference = Database.database().reference()
      
    //建立array
    var array_userName = [String]()
    var array_dateIn = [String]()
    var array_dateOut = [String]()
  //  var array_roomType = [String]()
    var array_pplNum = [String]()
    var array_phone = [String]()
    var array_done = [String]()
    var array_email = [String]()
    var array_orderID = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRecentOrder()
        tableView.reloadData()
        
        let refreshControl = UIRefreshControl()
        //修改顯示文字的顏色
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.purple]
        refreshControl.attributedTitle = NSAttributedString(string: "Loading", attributes: attributes)
        //設定元件顏色
        refreshControl.tintColor = UIColor.white
        //設定背景顏色
        // refreshControl.backgroundColor =
        //將元件加入TableView的視圖中
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
        
        dismiss(animated: true, completion: nil)
        
      }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
      // MARK: - Table view data source
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? detailTableViewController
          
        if let row = tableView.indexPathForSelectedRow?.row{
            controller?.orderName = array_userName[row]
            controller?.orderDateIn = array_dateIn[row]
            controller?.orderDateOut = array_dateOut[row]
            controller?.orderEmail = array_email[row]
            // controller?.orderRoomtype = array_roomType[row]
            controller?.orderppl = array_pplNum[row]
            controller?.orderphone = array_phone[row]
            controller?.orderDone = array_done[row]
            controller?.orderid = array_orderID[row]
              
        }
            
    }
   
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_userName.count
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             
        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! mainOrderTableViewCell
        
        // Configure the cell...
        cell.accessoryType = .disclosureIndicator
        cell.userNameLabel.text = array_userName[indexPath.row]
        cell.timeLabel.text = array_dateIn[indexPath.row]
        cell.orderStatusLabel.text = array_done[indexPath.row]
        
        if cell.orderStatusLabel.text == "已完成" {
            cell.orderStatusLabel.textColor = UIColor.orange
        }else{
            cell.orderStatusLabel.textColor = UIColor.black
        }
        

        return cell
         
    }
    
    @IBAction func refreshData(_ sender: UIBarButtonItem) {

        // 使用 UIView.animate 彈性效果，並且更改 TableView 的 ContentOffset 使其位移
        // 動畫結束之後使用 loadData()
       // UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseIn, animations: {
        //    self.tableView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.bounds.height)
      //  }) { (finish) in
       //     self.loadData()
     //   }
    }
}

extension mainOrderViewController{
    func loadRecentOrder() {
        if let user = Auth.auth().currentUser{
            let hostelName:String = user.displayName!
            let OrderDatabaseRef = Database.database().reference().child("CheckOrder").child(hostelName).queryOrdered( byChild: "ID_LivingDate")
        //    OrderDatabaseRef = OrderDatabaseRef.queryLimited(toLast: 10)
            OrderDatabaseRef.observe(.childAdded, with: {(snapshot) in
                let Name = snapshot.childSnapshot(forPath: "Client_Name").value as! String
                let dateIN = snapshot.childSnapshot(forPath: "ID_LivingDate").value as! String
                let dateOUT = snapshot.childSnapshot(forPath: "ID_LivingDate").value as! String
                let Number = snapshot.childSnapshot(forPath: "ID_PeopleNumber").value as! String
                let email = snapshot.childSnapshot(forPath: "Client_Email").value as! String
                let Phone = snapshot.childSnapshot(forPath: "Client_Phone").value as! String
                let doneOrNot = snapshot.childSnapshot(forPath: "doneOrNot").value as! String

                let orderID = snapshot.key
                print("orderID value: \(orderID)")
               // let roomType = snapshot.childSnapshot(forPath: "").value as! String
                
                self.array_userName.append(Name)
                self.array_dateIn.append(dateIN)
                self.array_email.append(email)
                self.array_pplNum.append(Number)
                self.array_phone.append(Phone)
                self.array_done.append(doneOrNot)
                self.array_orderID.append(orderID)
                self.array_dateOut.append(dateOUT)
                self.tableView.reloadData()
                  
                self.DB_ref.removeAllObservers()
            
                //沒有資料的cell欄位隱藏分隔線
                //self.tableView.tableFooterView = UIView(frame: CGRect.zero)
                
          })
        }
    }
    
    
    @objc func loadData(){
        
        self.array_userName.removeAll()
        self.array_dateIn.removeAll()
        self.array_email.removeAll()
        self.array_pplNum.removeAll()
        self.array_phone.removeAll()
        self.array_done.removeAll()
        self.array_orderID.removeAll()
        self.array_dateOut.removeAll()
        // 新增資料
        self.loadRecentOrder()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
            // 停止 refreshControl 動畫
        
        
    }
    
    func timecheck(){
        //當前時間
        let now = Date()
         
        //當前時間戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStampNow = Int(timeInterval)
        print("當前時間戳：\(timeStampNow)")
        
    }
    
}
