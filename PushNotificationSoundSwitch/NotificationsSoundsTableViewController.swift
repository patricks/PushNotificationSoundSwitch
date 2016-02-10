//
//  NotificationsSoundsTableViewController.swift
//  PushNotificationSoundSwitch
//
//  Created by Patrick Steiner on 10.02.16.
//  Copyright © 2016 Patrick. All rights reserved.
//

import UIKit
import AVFoundation

class NotificationsSoundsTableViewController: UITableViewController {
    
    private let cellIdentifier = "NotificationSoundCell"
    private let soundfileName = "demosound.caf"
    
    private var notificationSounds = [NotificationSound]()
    private var audioPlayer: AVAudioPlayer!
    private let settingsManager = SettingsManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load available sounds
        setupNotificationSounds()
    }
    
    func setupNotificationSounds() {
        // add all available sounds
        notificationSounds = NotificationSound.all()
        
        self.tableView.reloadData()
    }
    
    // MARK: Play Sound
    /**
    Play the sound file from the main bundle.
    */
    private func playSound(filename: String) {
        if let soundPath = NSBundle.mainBundle().pathForResource(filename, ofType: "caf") {
            do {
                let sound = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: soundPath))
                audioPlayer = sound
                sound.play()
            } catch {
                print("ERROR: Unable to play sound file: \(soundPath)")
            }
        } else {
            print("ERROR: Can't find sound file \(filename)")
        }
    }
    
    /**
     Test method to test the push notification. Sends a local push notification after 5 seconds.
     */
    private func playLocalNotification() {
        if let filename = settingsManager.notificationSoundFilename {
            
            print("DBG: using local push sound: \(soundfileName)")
            
            let localNotification = UILocalNotification()
            
            localNotification.alertTitle = "Push Test"
            localNotification.alertBody = "Alert Sound: \(filename)"
            localNotification.soundName = soundfileName
            
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            //UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
        }
    }
    
    // MARK: Persistant store selected sound
    
    /**
    Store the notification sound.
    - Save the filename into the NSUserDefaults.
    - Copy the file into the $APPDIR/Library/Sounds folder.
    */
    private func storeNotificationSound(notificationSound: NotificationSound) {
        if let filename = notificationSound.filename {
            print("DBG: saving filename: \(filename)")
            
            // store file after it is copied to the library
            copySoundFileToLibrary(filename)
            settingsManager.notificationSoundFilename = notificationSound.filename
            
            // play a local notification.
            // This only works the first time, after the app gets installed,
            // or the device gets rebooted.
            playLocalNotification()
            
        } else {
            print("ERROR: Couldn't store sound file, no filename")
        }
    }
    
    /**
    Remove the notification sound.
    - Remove the filename from the NSUserDefaults.
    - Remove the file from the $APPDIR/Library/Sounds folder.
    */
    private func removeNotificationSound() {
        // remove old file before the setting is set to nil
        removeSoundfileFromLibrary()
        settingsManager.notificationSoundFilename = nil
    }
    
    // MARK: Copy / remove sound from the library dictionary
    
    /**
    Copy the file from the main bundle into the $APPDIR/Library/Sounds dictionary.
    */
    private func copySoundFileToLibrary(filename: String) {
        if let srcPath = NSBundle.mainBundle().pathForResource(filename, ofType: "caf") {
            let libPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
            let destPath = "\(libPath)/Sounds" // $APPDIR/Library/Sound
            let destFile = "\(destPath)/\(soundfileName)"
            
            do {
                if !NSFileManager.defaultManager().fileExistsAtPath(destPath) {
                    try NSFileManager.defaultManager().createDirectoryAtPath(destPath, withIntermediateDirectories: false, attributes: nil)
                }
                
                // first remove the old file from the library dictionary
                removeSoundfileFromLibrary()
                
                try NSFileManager.defaultManager().copyItemAtPath(srcPath, toPath: destFile)
            } catch {
                print("ERROR: \(error)")
            }
        } else {
            print("ERROR: Soundfile \(filename) not found")
        }
    }
    
    /**
    Remove the soundfile from the $APPDIR/Library/Sounds dictionary.
    */
    private func removeSoundfileFromLibrary() {
        let libPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        let soundfilePath = "\(libPath)/Sounds" // $Applicationdir/Library/Sounds
        let soundfile = "\(soundfilePath)/\(soundfileName)"
        
        do {
            if NSFileManager.defaultManager().isDeletableFileAtPath(soundfile) {
                try NSFileManager.defaultManager().removeItemAtPath(soundfile)
            } else {
                print("DBG: Soundfile doesn't exist \(soundfile)")
            }
        } catch {
            print("ERROR: \(error)")
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension NotificationsSoundsTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationSounds.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let notificationSound = notificationSounds[indexPath.row]
        
        switch notificationSound.type {
        case .Default:
            if audioPlayer != nil {
                audioPlayer.stop()
            }
            
            // Doesn't work on the Simulator
            AudioServicesPlaySystemSound(1007) // default push notification sound
            
            removeNotificationSound()
        case .Custom:
            if let filename = notificationSound.filename {
                playSound(filename)
                
                storeNotificationSound(notificationSound)
            }
        }
        
        self.tableView.reloadData()
    }
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let notificationSound = notificationSounds[indexPath.row]
        
        cell.textLabel?.text = notificationSound.name
        
        switch notificationSound.type {
        case .Custom:
            if let filename = notificationSound.filename, savedFilename = settingsManager.notificationSoundFilename {
                if filename == savedFilename {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            } else {
                cell.accessoryType = .None
            }
        case .Default:
            if let _ = settingsManager.notificationSoundFilename {
                cell.accessoryType = .None
            } else {
                cell.accessoryType = .Checkmark
            }
        }
    }
}
