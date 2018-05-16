# comp495-sp18-travely
Trave.ly CS Senior Project (COMP 495 @ USD)

## How to install + run
1. In your Xcode project, pull from `develop`.
2. Open `terminal` (`Command + Space`, then search for "terminal").
3. `cd` into the same directory as where your code for Trave.ly is stored.

    For example, if my code is on the Desktop, then I'll need to use `cd Desktop/comp495-sp18-travely`.
4. Use the following commands to install `CocoaPods`:
  
    `sudo gem install cocoapods`
    
    `pod setup`   <-- this is a big file, it may take a few minutes
    
    `pod install`
5. Once the installation has finished, quit Xcode.
6. Open Cheers in Finder. In your Cheers folder you should see two Xcode files, a blue one that ends in `.xcodeproj` and a white one that ends in `.xcworkspace`. Double click on the white `.xcworkspace` file to open the project (you'll have to use white icon from now on).
7. `Command + R` to build and run!

If you have any issues, please refer to [this helpful Stack Overflow post](https://stackoverflow.com/questions/20755044/how-to-install-cocoapods).
