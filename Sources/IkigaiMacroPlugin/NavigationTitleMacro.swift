//
//  NavigationTitleMacro.swift
//  Heroes
//
//  Created by Vince Davis on 9/5/24.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct NavigationTitleMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let argument = node.arguments?.as(LabeledExprListSyntax.self)?.first?.expression,
              let stringLiteral = argument.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content else {
            throw MacroError.invalidArgument
        }

        let titleValue = stringLiteral.text

        let newBodyCode = """
        var body: some View {
            NavigationView {
                VStack {
                    Text("Name")
                }
                .navigationTitle("\(titleValue)")
            }
        }
        """

        return [DeclSyntax(stringLiteral: newBodyCode)]
    }
}

public enum MacroError: Error, CustomStringConvertible {
    case invalidArgument

    public var description: String {
        switch self {
        case .invalidArgument:
            return "The NavigationTitle macro requires a string literal argument."
        }
    }
}
