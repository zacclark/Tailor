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
        tasks.forEach({ task in task.terminate() })
    }
    
    //MARK: - Private
    
    func updateMenu() {
        statusItem.menu = buildMenuForProcfiles(
            procfiles,
            onLoadProcfile: pickProcfile,
            onQuit: imDONE,
            onStartEntry: letsTryLaunchingThisEh,
            onLogEntry: { procfile, entry in print("Log \(entry)") }
        ).asNSMenu
    }

    private var tasks: [NSTask] = []
    func letsTryLaunchingThisEh(procfile: Procfile, entry: Procfile.Entry) {
        guard let directory = procfile.URL.standardizedURL?.URLByDeletingLastPathComponent?.path else { return }

        let task = NSTask()
        task.currentDirectoryPath = directory
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", entry.command]
        task.launch()
        tasks.append(task)
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
