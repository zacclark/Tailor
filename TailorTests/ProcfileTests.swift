import XCTest

@testable import Tailor

class ProcfileTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }

    func testLoadingProcfile() {
        let bundle = NSBundle(forClass: ProcfileTests.self)
        let procfileURL = bundle.URLForResource("Procfile", withExtension: "")
        let procfile = Procfile(fileURL: procfileURL!)!
        
        XCTAssertEqual(procfile.name, "Resources")
        XCTAssertEqual(procfile.entries.count, 2)
        XCTAssertEqual(procfile.URL, procfileURL)
        XCTAssertEqual(procfile.entries[0].name, "example")
        XCTAssertEqual(procfile.entries[0].command, "yes \"long running task\"")
        XCTAssertEqual(procfile.entries[1].name, "other")
        XCTAssertEqual(procfile.entries[1].command, "yes \"a second task\"")
    }

}
