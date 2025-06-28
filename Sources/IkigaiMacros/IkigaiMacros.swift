//
//  IkigaiMacros.swift
//  IkigaiCore
//
//  Created by Vince Davis on 2/25/25.
//

@attached(member, names: named(body))
public macro NavigationTitle(_ title: String) = #externalMacro(module: "IkigaiMacroPlugin", type: "NavigationTitleMacro")
