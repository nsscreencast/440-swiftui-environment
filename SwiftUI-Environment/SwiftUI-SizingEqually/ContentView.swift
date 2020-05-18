//
//  ContentView.swift
//  SwiftUI-SizingEqually
//
//  Created by Ben Scheirman on 5/14/20.
//  Copyright © 2020 Fickle Bits, LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State var buttonWidth: CGFloat?

    var body: some View {
        Rectangle()
            .fill(Color(.secondarySystemFill))
            .frame(height: 80)
        .overlay(
            HStack {
                ToolbarButton(label: "Btn1")

                Spacer()
                ToolbarButton(label: "center")

                Spacer()
                ToolbarButton(label: "Button 3")
            }
            .environment(\.toolbarButtonWidth, self.buttonWidth)
            .environment(\.toolbarButtonColor, .purple)
            .onPreferenceChange(ToolbarButtonSizePreference.self) {
                self.buttonWidth = $0?.width
            }
            .padding()
        )
    }
}

struct ToolbarButtonWidthKey: EnvironmentKey {
    static var defaultValue: CGFloat? = nil
}

struct ToolbarButtonColorKey: EnvironmentKey {
    static var defaultValue: Color? = nil
}

extension EnvironmentValues {
    var toolbarButtonWidth: CGFloat? {
        get { self[ToolbarButtonWidthKey.self] }
        set { self[ToolbarButtonWidthKey.self] = newValue }
    }

    var toolbarButtonColor: Color? {
        get { self[ToolbarButtonColorKey.self] }
        set { self[ToolbarButtonColorKey.self] = newValue }
    }
}


struct ToolbarButtonSizePreference: PreferenceKey {
    static var defaultValue: CGSize? = nil

    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        guard let next = nextValue() else {
            return
        }
        if value == nil {
            value = next
            return
        }

        let maxSize = [value!, next].max { $0.width < $1.width }
        value = maxSize
    }
}

struct ToolbarButton: View {
    let label: String

    @Environment(\.toolbarButtonWidth) var toolbarButtonWidth
    @Environment(\.toolbarButtonColor) var buttonColor

    var body: some View {
        Text(label)
        .padding(10)
        .frame(width: self.toolbarButtonWidth)
        .background(
            Capsule()
                .fill(self.buttonColor ?? Color(.systemBlue))
                .shadow(radius: 1)
        )
        .foregroundColor(.white)
        .font(.headline)
        .modifier(ToolbarButtonSizeSetter())
    }
}

struct ToolbarButtonSizeSetter: ViewModifier {
    func body(content: Content) -> some View {
        content.overlay(GeometryReader { geometry in
            Color.clear.preference(key: ToolbarButtonSizePreference.self, value: geometry.size)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
