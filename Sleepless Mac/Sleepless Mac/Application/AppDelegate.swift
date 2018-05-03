//
//  AppDelegate.swift
//  Sleepless Mac
//
//  Created by Grzegorz Surma on 21/04/2018.
//  Copyright © 2018 Grzegorz Surma. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var sleeplessProcess: Process?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.highlightMode = false
        if let button = statusItem.button {
            button.action = #selector(toggleSleepMode)
        }
        
        startSleeplessProcess()
        setMenu()
    }
    
    func setMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: sleeplessProcess != nil ? "Allow sleeping" : "Disable sleeping", action: #selector(toggleSleepMode), keyEquivalent: "s"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Sleepless Mac", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }
    
    @objc func toggleSleepMode() {
        if sleeplessProcess != nil {
            terminateSleeplessProcess()
        } else {
            startSleeplessProcess()
        }
        setMenu()
    }
    
    func startSleeplessProcess() {
        statusItem.button?.image = #imageLiteral(resourceName: "NoSleep")
        sleeplessProcess = Process()
        sleeplessProcess?.launchPath = "/usr/bin/caffeinate"
        sleeplessProcess?.arguments = ["-i", "-d"]
        sleeplessProcess?.launch()
    }
    
    func terminateSleeplessProcess() {
        statusItem.button?.image = #imageLiteral(resourceName: "Sleep")
        sleeplessProcess?.terminate()
        sleeplessProcess = nil
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        terminateSleeplessProcess()
    }
}

