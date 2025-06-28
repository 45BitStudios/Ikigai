//
//  CompilerPlugin.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 9/5/24.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        NavigationTitleMacro.self
    ]
}
