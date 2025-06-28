//
//  OperatingSystem+Extensions.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 3/5/25.
//
import SwiftUI

public extension View {
    @ViewBuilder
    func ifOS<Content: View>(_ operatingSystems: OperatingSystem...,modifier: (Self) -> Content) -> some View {
        if operatingSystems.contains(OperatingSystem.current) {
            modifier(self)
        } else {
            self
        }
    }

    func modify<T: View>(@ViewBuilder modifier: (Self) -> T) -> T {
        modifier(self)
    }
}
