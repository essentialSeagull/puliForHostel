//
//  loginViewController.swift
//  puliForHostel
//
//  Created by viplab on 2020/5/26.
//  Copyright © 2020 viplab. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var emailTextField: RoundedTextField!{
        didSet
        {
            emailTextField.tag = 1
            emailTextField.becomeFirstResponder()
            emailTextField.delegate = self
        }
    }
    @IBOutlet var passwordTextField: RoundedTextField!{
        didSet
        {
            passwordTextField.tag = 2
            passwordTextField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.becomeFirstResponder()
    }
    
    @IBAction func login(sender: UIButton){
        //輸入驗證
        guard let emailAddress = emailTextField.text,emailAddress != "",
            let password = passwordTextField.text,password != ""
            else {
                let alertController = UIAlertController(title: "Login error", message: "不能空白", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                present(alertController, animated: true, completion: nil)
                return
        }
        
        //呼叫Firebase APIs執行登入
        Auth.auth().signIn(withEmail: emailAddress, password: password, completion: { (user, error) in
            if let error = error {
                let alertController = UIAlertController(title: "login error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //移除鍵盤
            self.view.endEditing(true)
            
            //連接的下一個視窗
           if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "main") as? mainOrderViewController
           {
                //傳遞navigation bar
                self.navigationController?.pushViewController(viewController, animated: true)
            
                self.dismiss(animated: true, completion: nil)
            }
            
        })
    }
    
    // MARK: - Navigation
    
    //按return時會到下一行
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        if textField.returnKeyType == UIReturnKeyType.done {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //點背景取消keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func gotoLogin(segue: UIStoryboardSegue)
    {//註冊back的segue
        let controller = UIAlertController(title: "是否確定要登出", message: "是的話請按ok", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
        
    }

}
