import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
    var procfiles: [Procfile] = []

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let dep = Procfile(name: "Example", entries: [
            ProcfileEntry(name: "web", command: ""),
            ProcfileEntry(name: "worker", command: ""),
            ProcfileEntry(name: "api-proxy", command: ""),
        ])
        procfiles.append(dep)
        
        statusItem.menu = buildMenu()
        
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
        }
    }
    
    func buildMenu() -> NSMenu {
        let menu = NSMenu()
        menu.title = "where does this go?"
        menu.autoenablesItems = false
        
        let titleItem = NSMenuItem(
            title: "Tailor - \(procfiles.count) Application(s)",
            action: nil,
            keyEquivalent: ""
        )
        titleItem.enabled = false
        
        menu.addItem(titleItem)
        menu.addItem(NSMenuItem.separatorItem())
        
        for procfile in procfiles {
            for item in itemsForProcfile(procfile) {
                menu.addItem(item)
            }
            menu.addItem(NSMenuItem.separatorItem())
        }
        
        menu.addItem(NSMenuItem(title: "Load Procfile", action: #selector(pickProcfile), keyEquivalent: "n"))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(imDONE), keyEquivalent: "q"))
        
        return menu
    }
    
    func pickProcfile(sender: AnyObject) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = [""]
        
        let ok = panel.runModal()
        if ok == NSModalResponseOK {
            if let potentialFile = panel.URL {
                print(potentialFile)
                print(potentialFile.URLByDeletingLastPathComponent?.lastPathComponent)
                let contents = try? String(contentsOfURL: potentialFile)
                print(contents)
            } else {
                print("no file")
            }
        } else {
            print("Cancelled")
        }
    }
    
    func imDONE() {
        NSRunningApplication.currentApplication().terminate()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Probably terminate anything managed here?
    }
}

struct ProcfileEntry {
    let name: String
    let command: String
}

struct Procfile {
    let name: String
    let entries: [ProcfileEntry]
}

func itemsForProcfile(procfile: Procfile) -> [NSMenuItem] {
    let titleItem = NSMenuItem(title: procfile.name, action: nil, keyEquivalent: "")
    titleItem.enabled = false
    
    let entryItems: [NSMenuItem] = procfile.entries.map { entry in
        let item = NSMenuItem(title: entry.name, action: nil, keyEquivalent: "")
        item.enabled = true
        return item
    }
    
    return [titleItem] + entryItems
}

