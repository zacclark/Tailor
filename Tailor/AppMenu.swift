import Cocoa

class AppMenu {
    let menu: NSMenu
    let loadProcfileCallback: Void -> Void
    let quitCallback: Void -> Void
    
    init( procfiles: [Procfile]
        , loadProcfileCallback: Void -> Void
        , quitCallback: Void -> Void
    ) {
        self.loadProcfileCallback = loadProcfileCallback
        self.quitCallback = quitCallback
        
        menu = NSMenu()
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
        
        menu.addItem(NSMenuItem(title: "Load Procfile", action: #selector(didClickPickProcfile), keyEquivalent: "n"))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(didClickQuit), keyEquivalent: "q"))
    }
    
    @objc private func didClickPickProcfile() {
        loadProcfileCallback()
    }
    
    @objc private func didClickQuit() {
        quitCallback()
    }
    
    private func itemsForProcfile(procfile: Procfile) -> [NSMenuItem] {
        let titleItem = NSMenuItem(title: procfile.name, action: nil, keyEquivalent: "")
        titleItem.enabled = false
        
        return [titleItem] + procfile.entries.map(itemForEntry)
    }
    
    private func itemForEntry(entry: Procfile.Entry) -> NSMenuItem {
        let item = NSMenuItem(title: entry.name, action: nil, keyEquivalent: "")
        item.enabled = true
        
        let submenu = NSMenu()
        
        submenu.addItem(NSMenuItem(title: "Start", action: nil, keyEquivalent: ""))
        submenu.addItem(NSMenuItem(title: "Logs", action: nil, keyEquivalent: ""))
        
        item.submenu = submenu
        
        return item
    }
}