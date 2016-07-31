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
    
    @IBOutlet weak var totalTimeTxt: NSTextField!
    @IBOutlet weak var balanceTxt: NSTextField!
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
    
    @IBAction func dama(sender: NSButton)  {
        
        let pwd = getpwd()
        let sign = getFileDataSign2()
        let type = "287"
        let fileData = getCurrentFileHex()
        let url = "http://api.dama2.com:7766/app/d2File"
        dama(url, appID: AppId, user: AppUser, pwd: pwd, type: type, fileData: fileData, sign: sign)
        
//        let damaCodes = "119,65|24,76"
//        self.imageView.drawDamaCodes(damaCodes)
    }
    
    @IBAction func clickGetBalance(Sender: NSButton){
        let url = "http://api.dama2.com:7766/app/d2Balance"
        let pwd = getpwd()
        let sign = getsign()
        getBalance(url, appID: AppId, user: AppUser, pwd: pwd, sign: sign)
    }
    
    func getCurrentFileBase64()->String {
        let imageData = self.imageView.image!.TIFFRepresentation
        let imageRep = NSBitmapImageRep(data: imageData!)
        let tiffData = imageRep?.representationUsingType(.NSPNGFileType, properties: ["NSImageCompressionFactor":1.0])
        
        let bas64 = tiffData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        print(bas64!)
        return bas64!
    }
    
    func getCurrentFileHex()->String {
        let originData = self.imageView.image!.TIFFRepresentation
        let imageRep = NSBitmapImageRep(data: originData!)
        let imageData = imageRep!.representationUsingType(.NSPNGFileType, properties: ["NSImageCompressionFactor":1.0])!
        
        let result = imageData.hexedString()
        
        print(result)
        return result
    }
    
    func getImagefromBase64(fileBase64:String){
        let data = NSData(base64EncodedString: fileBase64, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let image = NSImage(data: data!)
        self.imageView.image = image
    }
    
    func getpwd() -> String{
        let nameMD5 = AppUser.MD5()
        let passwordMD5 = AppSecret.MD5()
        let x1MD5 = (nameMD5 + passwordMD5).MD5()
        
        let x2MD5 = (AppKey + x1MD5).MD5()
//        print(x2MD5)
        return x2MD5
    }
    
    func getsign()->String {
        let key = AppKey + AppUser
        let x1MD5 = key.MD5()
        let x2 = x1MD5[x1MD5.startIndex...x1MD5.startIndex.advancedBy(7)]
        print(x2)
        return x2
    }
    
    func getFileDataSign()->String{
        let originData = self.imageView.image!.TIFFRepresentation
        let imageRep = NSBitmapImageRep(data: originData!)
        let imageData = imageRep!.representationUsingType(.NSPNGFileType, properties: ["NSImageCompressionFactor":1.0])!
        
        let result = imageData.hexedString()
        let key = AppKey + AppUser + result
        let x1MD5 = key.MD5()
        let x2 = x1MD5[x1MD5.startIndex...x1MD5.startIndex.advancedBy(7)]
        print(x2)
        return x2
    }
    
    func getFileDataSign2()->String{
        let originData = self.imageView.image!.TIFFRepresentation
        let imageRep = NSBitmapImageRep(data: originData!)
        let imageData = imageRep!.representationUsingType(.NSPNGFileType, properties: ["NSImageCompressionFactor":1.0])!
        
        let AppKeyData = AppKey.dataUsingEncoding(NSUTF8StringEncoding)
        let AppUserData = AppUser.dataUsingEncoding(NSUTF8StringEncoding)
        
        let finalData:NSMutableData = NSMutableData(data: AppKeyData!)
        finalData.appendData(AppUserData!)
        finalData.appendData(imageData)
        
        let x1MD5 = finalData.MD5().hexedString()
        let x2 = x1MD5[x1MD5.startIndex...x1MD5.startIndex.advancedBy(7)]
        print(x2)
        return x2
    }
    
    func getBalance(url:String,appID:Int,user:String,pwd:String,sign:String){
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
                
                print(response.timeline.totalDuration)
                self.totalTimeTxt.stringValue = String(response.timeline.totalDuration)
        }
    }
    
    
    func dama(url:String,appID:Int,user:String,pwd:String,type:String,fileData:String,sign:String){
        let params = ["appID":String(appID),
                      "user":user,
                      "pwd":pwd,
                      "type":type,
                      "fileData":fileData,
                      "sign":sign]
        Alamofire.request(.POST, url,parameters: params)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    self.imageView.drawDamaCodes(JSON.objectForKey("result") as! String)
                }
                
                print(response.timeline.totalDuration)
                self.totalTimeTxt.stringValue = String(response.timeline.totalDuration)
        }
    }

}

