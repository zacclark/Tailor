import Cocoa

protocol FilePicker {
    func pickFile() -> NSURL?
}

struct PanelFilePicker : FilePicker {
    func pickFile() -> NSURL? {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = [""]
        
        guard panel.runModal() == NSModalResponseOK else { return nil }
        return panel.URL
    }
}
