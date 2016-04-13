import Cocoa

typealias ProcfileEntryCallback = (Procfile, Procfile.Entry) -> Void

func buildMenuForProcfiles( procfiles       : [Procfile]
                          , onLoadProcfile  : Void -> Void
                          , onQuit          : Void -> Void
                          , onStartEntry    : ProcfileEntryCallback
                          , onLogEntry      : ProcfileEntryCallback
) -> Menu {
    let header : [MenuItem] = [
        .Label(title: "Tailor - \(procfiles.count) Application(s)"),
        .Separator
    ]

    let middle : [MenuItem] = procfiles.flatMap { pf in
        buildItemsForProcfile(
            pf,
            onStartEntry: onStartEntry,
            onLogEntry:  onLogEntry
        )
    }

    let footer : [MenuItem] = [
        .Action(title: "Load Procfile", action: onLoadProcfile),
        .Action(title: "Quit"         , action: onQuit)
    ]

    return Menu(items: header + middle + footer)
}

private func buildItemsForProcfile(
    procfile     : Procfile,
    onStartEntry : ProcfileEntryCallback,
    onLogEntry   : ProcfileEntryCallback
) -> [MenuItem] {
    return [ .Label(title: procfile.name) ]
    +
    procfile.entries.map { entry in
        let start = MenuItem.Action(title: "Start") { onStartEntry(procfile, entry) }
        let logs  = MenuItem.Action(title: "Logs") { onLogEntry(procfile, entry) }
        let items = [start, logs]

        return .SubMenu(title: entry.name, menu: Menu(items: items))
    }
    +
    [ .Separator ]
}

//MARK: - Menu Domain Objects

struct Menu {
    let items: [MenuItem]

    var asNSMenu : NSMenu {
        let menu = NSMenu()

        menu.autoenablesItems = false
        items.map({ $0.asNSMenuItem }).forEach(menu.addItem)

        return menu
    }
}

enum MenuItem {
    case Separator
    case Label(title: String)
    case Action(title: String, action: Void -> Void)
    case SubMenu(title: String, menu: Menu)

    var asNSMenuItem : NSMenuItem {
        switch self {
            case .Separator:
                return NSMenuItem.separatorItem()
            case let .Label(title):
                let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
                item.enabled = false
                return item
            case let .Action(title, action):
                let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
                MenuItemCallback(callback: action).installOn(item)
                return item
            case let .SubMenu(title, menu):
                let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
                item.submenu = menu.asNSMenu
                return item
        }
    }
}

private class MenuItemCallback : NSObject {
    let callback : Void -> Void

    init(callback: Void -> Void) {
        self.callback = callback

        super.init()
    }

    @objc func actionDidFire(sender: AnyObject) {
        callback()
    }

    func installOn(item: NSMenuItem) {
        item.representedObject = self
        item.target = self
        item.action = #selector(MenuItemCallback.actionDidFire(_:))
    }
}






