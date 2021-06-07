//
//  extension.swift
//  puliForHostel
//
//  Created by viplab on 2020/5/28.
//  Copyright © 2020 viplab. All rights reserved.
//

import Foundation

import UIKit


extension UIImage {
    func scale(newWidth: CGFloat) -> UIImage {
        // 確認所給定的寬度與目前的不同
        if self.size.width == newWidth {
            return self
        }
        // 計算縮放因子
        let scaleFactor = newWidth / self.size.width
        let newHeight = self.size.height * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0); self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
   
    func crop(ratio: CGFloat) -> UIImage {
            //計算尺寸
            var newSize:CGSize!
            if size.width/size.height > ratio {
                newSize = CGSize(width: size.height * ratio, height: size.height)
            }else{
                newSize = CGSize(width: size.width, height: size.width / ratio)
            }
         
            //圖片繪製區域
            var rect = CGRect.zero
            rect.size.width  = size.width
            rect.size.height = size.height
            rect.origin.x    = (newSize.width - size.width ) / 2.0
            rect.origin.y    = (newSize.height - size.height ) / 2.0
             
            //圖片呈現
            UIGraphicsBeginImageContext(newSize)
            draw(in: rect)
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
             
            return scaledImage ?? self
    }
}

extension UILabel{
    func mutiLine(){
        lineBreakMode = NSLineBreakMode.byWordWrapping
        numberOfLines = 0
        //最大行寬
        preferredMaxLayoutWidth = 320
    }
}


