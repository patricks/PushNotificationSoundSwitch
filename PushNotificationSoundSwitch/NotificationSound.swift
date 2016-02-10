//
//  NotificationSound.swift
//  PushNotificationSoundSwitch
//
//  Created by Patrick Steiner on 12.08.15.
//  Copyright (c) 2015 Mopius. All rights reserved.
//

import UIKit

enum NotificationSoundType {
    case Default
    case Custom
}

struct NotificationSound {
    var name: String
    var filename: String?
    var type: NotificationSoundType
    
    init(name: String, type: NotificationSoundType) {
        self.name = name
        self.type = type
        self.filename = nil
    }
    
    init (name: String, filename: String, type: NotificationSoundType) {
        self.name = name
        self.filename = filename
        self.type = type
    }
    
    static func name(filename: String) -> String {
        var name = ""
        
        switch filename {
        case "airhorn":
            name = NSLocalizedString("Airhorn", comment: "Notification Sound: Airhorn")
        case "police":
            name = NSLocalizedString("Police", comment: "Notification Sound: Police")
        case "redalert":
            name = NSLocalizedString("Red Alert", comment: "Notification Sound: Red Alert")
        case "schoolfire":
            name = NSLocalizedString("Schoolfire", comment: "Notification Sound: Schoolfire")
        case "tornadosiren":
            name = NSLocalizedString("Tornado", comment: "Notification Sound: Tornado")
        case "default":
            name = NSLocalizedString("Default", comment: "Notification Sound: Default")
        default:
            name = NSLocalizedString("Unknown", comment: "Notification Sound: Unknown")
        }
        
        return name
    }
    
    static func all() -> [NotificationSound] {
        var notificationSounds = [NotificationSound]()
        
        // default sound
        notificationSounds.append(NotificationSound(name: NotificationSound.name("default"), type: .Default))
        
        let filenames = ["airhorn", "police", "redalert", "schoolfire", "tornadosiren"]
        
        for filename in filenames {
            notificationSounds.append(NotificationSound(
                name: NotificationSound.name(filename),
                filename: filename,
                type: .Custom))
        }
        
        return notificationSounds
    }
}