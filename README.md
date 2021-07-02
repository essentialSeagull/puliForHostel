

# puliForHostel
  使用 Swift 語言撰寫的一個飯店預約系統之民宿業者端
 
 
## 製作動機
  埔里鎮是一個附近擁有多個景點的觀光鎮，故擁有許多民宿飯店，<br>但經過資料收集與訪查，發現多數的民宿飯店是沒有與大型訂房網站合作，只有在自己的網站提供訂房資訊。
  為了整合埔里鎮的民宿飯店以及提高小民宿的曝光度，故民宿預約系統的構想由此誕生。<br>另有飯店預約系統之用戶端，由他人撰寫，預計app開始有個入口可選擇身份，之後根據身份會進到不同頁面。
 
 
## Demo

### **login 頁面**
![image](/pics/login.png "相關controller:loginViewController.swift") <br>

### 主畫面
![image](/pics/%E5%9C%96%E7%89%87%201.png "相關controller:mainOrderViewController.swift") <br>
此介面為所有訂單頁面，擁有民宿業者從用戶端接收的所有訂單，使用queryOrdered排序 <br>
右上角可刷新訂單最新狀態<br>
![image](/pics/%E5%9C%96%E7%89%87%202.png "相關controller:detailTableViewController.swift") <br>
點擊其中一個訂單即可查看此訂單更詳細的資料，如入住人數及客戶電話等。<br>

### 側邊欄
![image](/pics/%E5%9C%96%E7%89%87%203.png "相關controller:sidemenuTableViewController.swift") <br>
側邊欄可以看到個人頭貼及名稱，以及登出button 以及進入個人民宿資訊的button <br>


### 民宿資訊
![image](/pics/%E5%9C%96%E7%89%87%204.png "相關controller:hostelInfoTableViewController") <br>
`這個頁面可看到民宿業者的個人資料，<br>
有帳號頭貼、民宿照片、名稱、電話、地址以及簡介。<br>
點擊右上角更改資訊button可修改民宿名稱以外的資訊。 ` <br>

![image](/pics/%E5%9C%96%E7%89%87%205.png "相關controller:changeInfoTableViewController.swift ")

![image](/pics/%E5%9C%96%E7%89%87%206.png "相關controller:changeInfoTableViewController.swift ")
