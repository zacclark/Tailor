import Foundation

struct Procfile {
    struct Entry {
        let name: String
        let command: String
        
        init(name: String, command: String) {
            self.name = name
            self.command = command
        }
        
        init?(line: String) {
            let pattern = "^([A-Za-z0-9_]+):\\s*(.+)$"
            guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
                return nil
            }
            
            let overallMatches = regex.matchesInString(line, options: [], range: NSMakeRange(0, line.characters.count))
            guard overallMatches.count == 1 else { return nil }
            let overallMatch = overallMatches[0]
            
            let ranges = (0...overallMatch.numberOfRanges-1).map { overallMatch.rangeAtIndex($0) }
            guard ranges.count == 3 else { return nil }
            
            let matches = ranges.map { (line as NSString).substringWithRange($0) }
            
            name = matches[1]
            command = matches[2]
        }
    }
    
    let name: String
    let entries: [Entry]
    let URL: NSURL
    
    init?(fileURL: NSURL) {
        guard let
            contents = try? String(contentsOfURL: fileURL),
            name = fileURL.URLByDeletingLastPathComponent?.lastPathComponent
        else {
            return nil
        }
        
        self.URL = fileURL
        self.name = name
        self.entries = contents
            .componentsSeparatedByString("\n")
            .flatMap(Entry.init)
    }
}