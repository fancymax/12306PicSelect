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
    @IBOutlet weak var imageView: RandCodeImageView!
    @IBOutlet weak var randCodeLabel: NSTextField!
    
    @IBAction func getRandCode(sender: AnyObject) {
        if imageView.randCodeStr != nil {
            randCodeLabel.stringValue = imageView.randCodeStr!
        }
        else {
            randCodeLabel.stringValue = "nil"
        }
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let image = NSImage(named: "getPassCodeNew.jpeg")
        self.imageView.image = image
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

