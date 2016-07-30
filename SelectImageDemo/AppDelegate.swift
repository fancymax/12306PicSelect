//
//  AppDelegate.swift
//  SelectImageDemo
//
//  Created by fancymax on 15/12/30.
//  Copyright © 2015年 fancy. All rights reserved.
//

import Cocoa

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

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

