//
//  SettingsManager.swift
//  LFK-Infos
//
//  Created by Patrick Steiner on 01.07.15.
//  Copyright (c) 2015 Mopius. All rights reserved.
//

import Foundation

class SettingsManager {
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    // Settings keys
    private let notificationFilenameKey = "notificationFilenameKey"
    
    // MARK: - Notification Sound
    
    var notificationSoundFilename: String? {
        get {
            return defaults.stringForKey(notificationFilenameKey)
        }
        
        set {
            defaults.setObject(newValue, forKey: notificationFilenameKey)
        }
    }
}
