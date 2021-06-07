//
//  orderDetailViewController.swift
//  puliForHostel
//
//  Created by viplab on 2020/5/26.
//  Copyright © 2020 viplab. All rights reserved.
//

import UIKit
class orderDetailViewController: UIViewController {
    
    @IBOutlet var nameL:UILabel!
    @IBOutlet var timeL:UILabel!
    @IBOutlet var roomTypeL:UILabel!
    @IBOutlet var PPLL:UILabel!
    @IBOutlet var phoneL:UILabel!
    
    var orderName: String?
    var orderTime: String?
    var orderRoomtype: String?
    var orderppl: String?
    var orderphone: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameL.text = orderName
        timeL.text = orderTime
        roomTypeL.text = orderRoomtype
        PPLL.text = orderppl
        phoneL.text = orderphone
        
        
        

        // Do any additional setup after loading the view.
    }
    

    

}
