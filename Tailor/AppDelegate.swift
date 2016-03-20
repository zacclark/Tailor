import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
    let defaults = NSUserDefaults.standardUserDefaults()
    var procfileURLs: [NSURL] = [] {
        didSet {
            defaults.setValue(procfileURLs.map{$0.absoluteString}, forKey: "procfileURLs")
        }
    }
    var procfiles: [Procfile] = []

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        defaults.registerDefaults([
            "procfileURLs": [NSURL]()
        ])
        if let storedURLs = defaults.valueForKey("procfileURLs") as? [String] {
            procfileURLs = storedURLs.flatMap(NSURL.init)
            procfiles = procfileURLs.flatMap(Procfile.init)
        }
        
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
        }
        
        updateMenu()
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Probably terminate anything managed here?
    }
    
    //MARK: - Private
    
    func updateMenu() {
        statusItem.menu = AppMenu(
            procfiles: procfiles,
            loadProcfileCallback: pickProcfile,
            quitCallback: imDONE
        ).menu
    }
    
    func pickProcfile() {
        if let procfile = PanelFilePicker().pickFile().flatMap(Procfile.init) {
            procfileURLs.append(procfile.URL)
            procfiles.append(procfile)
            updateMenu()
        }
    }
    
    func imDONE() {
        NSRunningApplication.currentApplication().terminate()
    }
}
