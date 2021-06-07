//
//  upload&download.swift
//  puliForHostel
//
//  Created by viplab on 2020/6/1.
//  Copyright © 2020 viplab. All rights reserved.
//

import Foundation
import Firebase
import Kingfisher

final class PictureService {
    //example:   PictureService.shared.POST_DB_REF
    static let shared: PictureService = PictureService()
    private init() { }
    
    // MARK: - Firebase 參照
    var user = Auth.auth().currentUser
    var DB_ref: DatabaseReference = Database.database().reference()
    var SR_ref: StorageReference = Storage.storage().reference().child("photo")
    
    
    func uploadImage(image: UIImage){
        
        let uniqueString = NSUUID().uuidString
        let imageStorageRef = SR_ref.child(user!.uid).child("飯店照片").child("\(uniqueString).jpg")
        let DBref =  DB_ref.child("Hotel_Info").child(self.user!.uid).child("Hotel_Photo")
        // Resize the image
        let cropImage = image.crop(ratio: 16/9)
        let scaleImage = cropImage.scale(newWidth: 375)
        
        guard let imageData = scaleImage.jpegData(compressionQuality: 0.9) else {
            return
        }
        
        // 建立檔案的元資料
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // 上傳任務準備
        let uploadTask = imageStorageRef.putData(imageData, metadata: metadata)
        
        // 觀察上傳狀態
        uploadTask.observe(.success) { (snapshot) in
            snapshot.reference.downloadURL(completion: { (url, error) in
    
                // 在資料庫加上一個參照
                if let imageFileURL = url?.absoluteString{
                    //上傳資料到database
                    let picData = imageFileURL
                    DBref.child("Hotel_PhotoImage").setValue(picData)
                }
            })
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("Uploading Picture... \(percentComplete)% complete")
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error { print(error.localizedDescription)
            }
        }
    }
    
    func uploadHeadPic(Headimage: UIImage){
        
        let uniqueString = NSUUID().uuidString
        let imageStorageRef = SR_ref.child(user!.uid).child("頭像照片").child("\(uniqueString).jpg")
        let DBref =  DB_ref.child("Hotel_Info").child(self.user!.uid).child("Hotel_Photo")
        let cropHeadImage = Headimage.crop(ratio: 1)
        let scaleImage = cropHeadImage.scale(newWidth: 100)
        
        guard let imageData = scaleImage.jpegData(compressionQuality: 0.9) else {
            return
        }
        
        // 建立檔案的元資料
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // 上傳任務準備
        let uploadTask = imageStorageRef.putData(imageData, metadata: metadata)
        
        // 觀察上傳狀態
        uploadTask.observe(.success) { (snapshot) in
            snapshot.reference.downloadURL(completion: { (url, error) in
    
                // 在資料庫加上一個參照
                if let imageFileURL = url?.absoluteString{
                    //上傳資料到database
                    let picData = imageFileURL
                    DBref.child("Hotel_HeadPic").setValue(picData)
                }
            })
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("Uploading Head Picture... \(percentComplete)% complete")
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error { print(error.localizedDescription)
            }
        }
    }
    
    func downloadPic(PhotoView: UIImageView){
        
        DB_ref.child("Hotel_Info").child(user!.uid).child("Hotel_Photo").observe( .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let imageURL = value?["Hotel_PhotoImage"] as? String
            //reset image view
            PhotoView.image = nil
        
            //download image
            let url = URL(string: imageURL!)
            PhotoView.kf.indicatorType = .activity
            PhotoView.kf.setImage(with: ImageResource(downloadURL: url!))
            {
                result in
                switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                }
            }
            
        })
    }

    func downloadHeadPic(headPicView: UIImageView){
        
        DB_ref.child("Hotel_Info").child(user!.uid).child("Hotel_Photo").observe( .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let headPicURLstring = value?["Hotel_HeadPic"] as? String
        
            //reset image view
            headPicView.image = nil
            let url = URL(string: headPicURLstring!)
            
            headPicView.kf.indicatorType = .activity
            headPicView.kf.setImage(with: ImageResource(downloadURL: url!))
            {
                result in
                switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                }
            }
        })
    }
    func downloadHeadPic(headPicButton: UIButton){
        
        DB_ref.child("Hotel_Info").child(user!.uid).child("Hotel_Photo").observe( .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let headPicURLstring = value?["Hotel_HeadPic"] as? String
        
            //reset image view
            
            let url = URL(string: headPicURLstring!)
            headPicButton.kf.setImage(with: url, for: .normal)
            {
                result in
                switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                }
            }
        })
    }

}
