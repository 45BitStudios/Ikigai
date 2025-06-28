//
//  EmptyStateViewModifier.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 3/5/25.
//


import SwiftUI

struct EmptyStateViewModifier<EmptyContent>: ViewModifier where EmptyContent: View {
    var isEmpty: Bool
    let emptyContent: () -> EmptyContent

    func body(content: Content) -> some View {
        if isEmpty {
            emptyContent()
        }
        else {
            content
        }
    }
}

public extension View {
    func emptyState<EmptyContent>(_ isEmpty: Bool, emptyContent: @escaping () -> EmptyContent) -> some View where EmptyContent: View {
        modifier(EmptyStateViewModifier(isEmpty: isEmpty, emptyContent: emptyContent))
    }
}
