//
//  IceGroupBox.swift
//  Project: Veil
//
//  Copyright © 2023–2025 Jordan Baird
//  Copyright © 2026 MoeMoeGit
//  Licensed under the GNU GPLv3

import SwiftUI

struct IceGroupBox<Header: View, Content: View, Footer: View>: View {
    private let header: Header
    private let content: Content
    private let footer: Footer
    private let padding: EdgeInsets

    private var backgroundShape: some InsettableShape {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
    }

    private var glassFill: Color {
        Color(red: 0.9, green: 0.97, blue: 1.0).opacity(0.18)
    }

    private var glassStroke: Color {
        Color(red: 0.65, green: 0.86, blue: 1.0).opacity(0.32)
    }

    init(
        padding: EdgeInsets = .iceGroupBoxDefaultPadding,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.padding = padding
        self.header = header()
        self.content = content()
        self.footer = footer()
    }

    init(
        padding: CGFloat,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(padding: EdgeInsets(all: padding)) {
            header()
        } content: {
            content()
        } footer: {
            footer()
        }
    }

    init(
        padding: EdgeInsets = .iceGroupBoxDefaultPadding,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) where Header == EmptyView {
        self.init(padding: padding) {
            EmptyView()
        } content: {
            content()
        } footer: {
            footer()
        }
    }

    init(
        padding: CGFloat,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) where Header == EmptyView {
        self.init(padding: padding) {
            EmptyView()
        } content: {
            content()
        } footer: {
            footer()
        }
    }

    init(
        padding: EdgeInsets = .iceGroupBoxDefaultPadding,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) where Footer == EmptyView {
        self.init(padding: padding) {
            header()
        } content: {
            content()
        } footer: {
            EmptyView()
        }
    }

    init(
        padding: CGFloat,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) where Footer == EmptyView {
        self.init(padding: padding) {
            header()
        } content: {
            content()
        } footer: {
            EmptyView()
        }
    }

    init(
        padding: EdgeInsets = .iceGroupBoxDefaultPadding,
        @ViewBuilder content: () -> Content
    ) where Header == EmptyView, Footer == EmptyView {
        self.init(padding: padding) {
            EmptyView()
        } content: {
            content()
        } footer: {
            EmptyView()
        }
    }

    init(
        padding: CGFloat,
        @ViewBuilder content: () -> Content
    ) where Header == EmptyView, Footer == EmptyView {
        self.init(padding: padding) {
            EmptyView()
        } content: {
            content()
        } footer: {
            EmptyView()
        }
    }

    init(
        _ title: LocalizedStringKey,
        padding: EdgeInsets = .iceGroupBoxDefaultPadding,
        @ViewBuilder content: () -> Content
    ) where Header == Text, Footer == EmptyView {
        self.init(padding: padding) {
            Text(title).font(.headline)
        } content: {
            content()
        } footer: {
            EmptyView()
        }
    }

    init(
        _ title: LocalizedStringKey,
        padding: CGFloat,
        @ViewBuilder content: () -> Content
    ) where Header == Text, Footer == EmptyView {
        self.init(padding: padding) {
            Text(title).font(.headline)
        } content: {
            content()
        } footer: {
            EmptyView()
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            header
                .accessibilityAddTraits(.isHeader)
                .padding([.top, .leading], 8)
                .padding(.bottom, 2)

            contentStack
                .padding(padding)
                .background(backgroundShape.fill(glassFill))
                .glassEffect(.regular, in: backgroundShape)
                .overlay(
                    backgroundShape.strokeBorder(.white.opacity(0.5), lineWidth: 0.6)
                )
                .overlay(
                    backgroundShape.strokeBorder(glassStroke, lineWidth: 1.0)
                )
                .containerShape(backgroundShape)
                .shadow(color: Color(red: 0.08, green: 0.32, blue: 0.68).opacity(0.08), radius: 12, y: 5)

            footer
                .padding([.bottom, .leading], 8)
                .padding(.top, 2)
        }
        .focusSection()
        .accessibilityElement(children: .contain)
    }

    private var contentStack: some View {
        VStack { content }
    }
}

extension EdgeInsets {
    /// The default padding for an ``IceGroupBox``.
    static let iceGroupBoxDefaultPadding = EdgeInsets(all: 12)
}
