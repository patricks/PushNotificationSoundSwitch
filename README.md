# PushNotificationSoundSwitch
Demo App to reproduce the push notification sound file switching problem.

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
I have the same problems with remote notifications. If I send a remote notification after rebooting the device, the selected sound is played.
