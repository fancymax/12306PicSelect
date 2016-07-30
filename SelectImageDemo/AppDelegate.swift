//
//  AppDelegate.swift
//  SelectImageDemo
//
//  Created by fancymax on 15/12/30.
//  Copyright © 2015年 fancy. All rights reserved.
//

import Cocoa
import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var imageView: RandCodeImageView2!
    @IBOutlet weak var randCodeLabel: NSTextField!
    
    var currentImage = "a1.jpeg"
    var currentCount = 0
    
    let picNameArr = ["a1","a2","a3","a4","b1","b2","b3","b4","b5","b6","b7","b8","b9"]
    
    @IBAction func getRandCode(sender: AnyObject) {
        if imageView.randCodeStr != nil {
            randCodeLabel.stringValue = imageView.randCodeStr!
        }
        else {
            randCodeLabel.stringValue = "nil"
        }
    }

    @IBAction func getNextImage(sender: NSButton) {
        currentCount += 1;
        if currentCount >= picNameArr.count {
            currentCount = 0
        }
        currentImage = picNameArr[currentCount] + ".jpeg"
        self.imageView.image = NSImage(named: currentImage)
        self.imageView.clearRandCodes()
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let image = NSImage(named: currentImage)
        self.imageView.image = image
    }
    
    @IBAction func test(sender: NSButton)  {
        let pwd = getpwd()
        let sign = getsign()
        
        let url = "http://api.dama2.com:7766/app/d2Balance"
        test3(url, appID: AppId, user: AppUser, pwd: pwd, sign: sign)
        
    }
    
    func getpwd() -> String{
        let nameMD5 = AppUser.MD5()
        let passwordMD5 = AppSecret.MD5()
        let x1MD5 = (nameMD5 + passwordMD5).MD5()
        
        let x2MD5 = (AppKey + x1MD5).MD5()
        print(x2MD5)
        return x2MD5
    }
    
    func getsign()->String {
        let key = AppKey + AppUser
        let x1MD5 = key.MD5()
        let x2 = x1MD5[x1MD5.startIndex...x1MD5.startIndex.advancedBy(7)]
        print(x2)
        return x2
    }
    
    func test3(url:String,appID:Int,user:String,pwd:String,sign:String){
        let urlX = "\(url)?appID=\(appID)&user=\(user)&pwd=\(pwd)&sign=\(sign)"
        Alamofire.request(.GET, urlX)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }


}

