# PushNotificationSoundSwitch
Sample App to reproduce the push notification sound file switching problem.

# The problem
I want to have a solution to switch between different remote notification sounds, without storing something on the backend. So I tried to store different sounds in the main bundle of the app, and let the user decide which sound he wants. If the sound is selected I copy the file to ```$APPDIR/Library/Sounds``` with a specific filename (```demo.caf```). So I can push to a group of people, an everybody gets a different notification sound. The problem is, that if I copy the file into the ```$APPDIR/Library/Sounds``` dictionary the first time, everything works fine. If I switch the file the second time (remove the old one, copy the new one to the same place, with the same name) the sound isn't played anymore. If I reboot the iOS device, the new sound is played until I switch to another file again.

The ```Library/Sounds``` directory should work as notification sound directory, have a look at the documentation at:
[Apple Remote Notification Documentation](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/IPhoneOSClientImp.html#//apple_ref/doc/uid/TP40008194-CH103-SW1) 

So I have written a little sample app, this one uses local notifications, because they are easier to setup.

# Steps to reproduce the problem
- Build the app with Xcode.
- Launch the app on an iOS device. (Don't use the simulator)
- Select a notification sound.
- Now you have 5 seconds to put the app into the background, or close the app.
- After 5 seconds the local notification should appear an also play the selected sound.
- Lauch the app again, and select another sound.
- You have again 5 seconds to put the app in the background, or close the app.
- The local notification appears, but there is no notification sound.

# Extra notes
I have the same problem with remote notifications. If I send a remote notification after rebooting the device, the selected sound is played.
