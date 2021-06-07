//
//  changeInfoTableViewController.swift
//  puliForHostel
//
//  Created by viplab on 2020/5/26.
//  Copyright © 2020 viplab. All rights reserved.
//

import UIKit
import Firebase
import FMPhotoPicker
import ImagePicker
import Kingfisher

class changeInfoTableViewController: UITableViewController, UITextFieldDelegate,UITextViewDelegate, FMImageEditorViewControllerDelegate{
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    @IBOutlet var NameTextField: RoundedTextField!
    @IBOutlet var PhonenumberTextField: RoundedTextField!{
        didSet{
            PhonenumberTextField.tag = 1
            PhonenumberTextField.becomeFirstResponder()
            PhonenumberTextField.delegate = self
        }
    }
    @IBOutlet var WhereTextField: RoundedTextField!{
        didSet{
            WhereTextField.tag = 2
            WhereTextField.delegate = self
            
        }
    }
    @IBOutlet var IntroTextView: UITextView!{
        didSet{
            IntroTextView.tag = 3
            IntroTextView.layer.cornerRadius = 5.0
            IntroTextView.layer.borderWidth = 1.0
            IntroTextView.layer.borderColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1).cgColor
            IntroTextView.layer.masksToBounds = true
            //鍵盤“return”變成“完成”
            IntroTextView.returnKeyType = UIReturnKeyType.done
            IntroTextView.delegate = self
        }
    }
    @IBOutlet weak var headPic: UIButton!{
        didSet {
        headPic.layer.cornerRadius = 50.0
        headPic.clipsToBounds = true
        headPic.addTarget(self, action: #selector(self.HeadPicImagePicker), for: .touchUpInside)
        }
    }

               

    var Name: String?
    var Place: String?
    var Phone: String?
    var Introduction: String?
    var imageURLstring: String?
    var headPicURLstring: String?
    var currentURL: String?

    var user = Auth.auth().currentUser
    var DB_ref: DatabaseReference = Database.database().reference()
    var SR_ref: StorageReference = Storage.storage().reference().child("photo")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            DB_ref.child("Hotel_Info").child(user!.uid).observe( .value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                self.Name = value?["Hotel_Name"] as? String
                self.Introduction = value?["Hotel_Introduction"] as? String
                self.Place = value?[ "Hotel_Address"] as? String
                self.Phone = value?["Hotel_Phone"] as? String
                
                self.NameTextField.text = self.Name
                self.WhereTextField.text = self.Place
                self.PhonenumberTextField.text = self.Phone
                self.IntroTextView.text = self.Introduction
                
                PictureService.shared.downloadPic(PhotoView: self.photoImageView)
                PictureService.shared.downloadHeadPic(headPicButton: self.headPic)
               // self.downloadPic()
        
                self.tableView.reloadData()
                self.DB_ref.removeAllObservers()
            
                self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        })
        
        //UIbutton
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    //photoPicker config

    
    func pressSure()
    {
        let alertController = UIAlertController(title: "修改成功", message: "已經修改成功囉", preferredStyle: .alert)
               let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               alertController.addAction(alertAction)
               present(alertController, animated: true, completion: nil)
    }
    @IBAction func Changemyvalue(sender :UIBarButtonItem)
    {
        let updateData:[String: Any] = ["Hotel_Name": NameTextField.text!,
                                        "Hotel_Phone": PhonenumberTextField.text!,
                          "Hotel_Address": WhereTextField.text!,
                          "Hotel_Introduction": IntroTextView.text!
        ]
        DB_ref.child("Hotel_Info").child(user!.uid).updateChildValues(updateData as [String? : Any])
        
        //更改authentication 的
        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest(){
            changeRequest.displayName =  NameTextField.text
            changeRequest.commitChanges(completion: {(error) in
                if let error = error {
                    print("Failed to change name: \(error.localizedDescription)")
                }
            })
        }
            
        let controller = UIAlertController(title: "是否要修改", message: "確認修改請按確定～", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default){action in self.pressSure()}
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
        
    }
    //textView點擊return（換行）關閉鍵盤
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.view?.endEditing(false)
            return false
        }

        //字數限制，在這裏我的處理是給了一個簡單的提示，
        if range.location >= 200 {
            print("超過200字數了")
            return false
        }
        return true
    }
    
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
    
    func handler(gesture: UISwipeGestureRecognizer) {
        IntroTextView.resignFirstResponder()
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "main") as? mainOrderViewController
        {
             //傳遞navigation bar
             self.navigationController?.pushViewController(viewController, animated: true)
         
             self.dismiss(animated: true, completion: nil)
         }
        self.dismiss(animated: true, completion:nil)
    }
    
    @objc func HeadPicImagePicker(){
            let controller = UIAlertController(title: "上傳個人頭貼", message: "請選擇要上傳的圖片 \n", preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "開啟相機拍照", style: .default) { (void) in
                self.Headcamera()
            }
            let libraryAction = UIAlertAction(title: "從相簿中選擇", style: .default) { (void) in
                self.HeadPhotoPicker()
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
    
            controller.addAction(libraryAction)
            controller.addAction(cameraAction)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {      //選第一個cell時
        
            let controller = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "開啟相機拍照", style: .default) { (void) in
                self.camera()
            }
            let libraryAction = UIAlertAction(title: "從相簿中選擇", style: .default) { (void) in
                self.photoPicker()
            }
           let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
           controller.addAction(cameraAction)
           controller.addAction(libraryAction)
           controller.addAction(cancelAction)
           present(controller, animated: true, completion: nil)
        }
            
    }

}

// MARK: - FMPHOTOPICKER 相關設定
extension changeInfoTableViewController: FMPhotoPickerViewControllerDelegate{
    
    
    func config() -> FMPhotoPickerConfig {
        
        var mediaTypes = [FMMediaType]()
        mediaTypes.append(.image)
        
        var config = FMPhotoPickerConfig()
        
        config.selectMode = .single //單張照片模式
        config.mediaTypes = mediaTypes
        
        // in force crop mode, only the first crop option is available
        config.availableCrops = [   FMCrop.ratio16x9 ]
        config.forceCropEnabled = false
        config.eclipsePreviewEnabled = false
        
        // all available filters will be used
        config.availableFilters = []
        
        return config
    }
    
    func configHeadPic() -> FMPhotoPickerConfig {
        
        var mediaTypes = [FMMediaType]()
        mediaTypes.append(.image)
        
        var config = FMPhotoPickerConfig()
        
        config.selectMode = .single //單張照片模式
        config.mediaTypes = mediaTypes
        config.forceCropEnabled = true
        config.eclipsePreviewEnabled = true
        
        // in force crop mode, only the first crop option is available
        config.availableCrops = [   FMCrop.ratioSquare ]
        
        // all available filters will be used
        config.availableFilters = []
        
        return config
    }
    
    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
     //   let photoRef: DatabaseReference = DB_ref.child("Hotel_Info").child(user!.uid).child("Hotel_Photo")
        
        let calu = photo.size.width / photo.size.height
        
        
        if calu <= 1.01 && calu >= 0.99 {
            
            PictureService.shared.uploadHeadPic(Headimage: photo)
        } else if calu <= 1.79 && calu >= 1.77 {
            PictureService.shared.uploadImage(image: photo)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        guard let photo = photos.first else {
                       dismiss(animated: true, completion: nil)
            return}
        
        let calu = photo.size.width / photo.size.height

        if calu <= 1.01 && calu >= 0.99 {
            PictureService.shared.uploadHeadPic(Headimage: photo)
        } else if calu <= 1.79 && calu >= 1.77 {
            PictureService.shared.uploadImage(image: photo)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    //相冊選擇器＿fmPhotoPicker
    func photoPicker() {
        let picker = FMPhotoPickerViewController(config: config())
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
   
    func photoEditer(image: UIImage) {
        let picker = FMImageEditorViewController(config: config(), sourceImage: image)
        picker.delegate = self
        
        self.present(picker,animated: true)
    }
    func camera(){
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 5
        present(imagePickerController, animated: true, completion: nil)
    }
    //相冊選擇器＿fmPhotoPicker_頭像
    func HeadPhotoPicker() {
        let picker = FMPhotoPickerViewController(config: configHeadPic())
        picker.delegate = self
         
        self.present(picker, animated: true)
     }
    
     func HeadphotoEditer(image: UIImage) {
        let picker = FMImageEditorViewController(config: configHeadPic(), sourceImage: image)
        picker.delegate = self
         
        self.present(picker,animated: true)
     }
     func Headcamera(){
        let imagePickerController = ImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        
        present(imagePickerController, animated: true, completion: nil)
     }
    
}

extension changeInfoTableViewController: ImagePickerDelegate{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        dismiss(animated: true, completion: nil)
        guard let photo = images.first else {
                dismiss(animated: true, completion: nil)
                return
        }
        
        if imagePicker.imageLimit == 1 {
            HeadphotoEditer(image: photo)
        } else{
            photoEditer(image: photo)
        }
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
