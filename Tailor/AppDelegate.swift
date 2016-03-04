import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.action = #selector(AppDelegate.stuff(_:))
        }
    }
    
    func stuff(sender: AnyObject) {
        // yup
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Probably terminate anything managed here?
    }
}

