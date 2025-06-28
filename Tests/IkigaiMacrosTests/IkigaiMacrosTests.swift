import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
@testable import IkigaiMacros

final class NavigationTitleMacroTests: XCTestCase {
    func testNavigationTitleMacroExpansion() {
        let source = """
        @NavigationTitle("Test Title")
        struct ContentView { }
        """

        // This is an example of what the expected expansion might look like.
        // Adjust the expected output based on what your macro actually injects.
        let expectedExpandedSource = """
        struct ContentView {
            var body: some View {
                NavigationView {
                    ContentView()
                }
                .navigationTitle("Test Title")
            }
        }
        """

        // Use the testing helper to assert that the macro expansion matches the expectation.
        assertMacroExpansion(
            source,
            expandedSource: expectedExpandedSource,
            macros: ["NavigationTitle": NavigationTitleMacro.self]
        )
    }
}
