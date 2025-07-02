//
//  AlertView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk  on 04.10.2023.
//

import SwiftUI

struct AlertView: View {
    private var presentation: AlertPresentation
    private let alertStyle: AlertStyle
    private let presentationStyle: AlertPresentationStyle
    private let additionalView: AnyView?

    init(
        presentation: AlertPresentation,
        alertStyle: AlertStyle,
        presentationStyle: AlertPresentationStyle,
        additionalView: AnyView? = nil
    ) {
        self.presentation = presentation
        self.alertStyle = alertStyle
        self.presentationStyle = presentationStyle
        self.additionalView = additionalView
    }

    var body: some View {
        ZStack {
            alphaBackgroundView(from: Constants.alphaBackgroundComponent)

            switch alertStyle {
            case .dialog:
                dialogContentView

            case .bottomSheet:
                bottomSheetContentView
            }

        }
        .edgesIgnoringSafeArea(presentationStyle == .overFullScreen ? [.top, .bottom] : .top)
    }

    var dialogContentView: some View {
        contentView
            .cornerRadius(Constants.contentCornerRadius)
            .clipped()
            .padding(.horizontal, 16)
    }

    var bottomSheetContentView: some View {
        VStack {
            Spacer()

            contentView
                .cornerRadius(Constants.contentCornerRadius, corners: [.topLeft, .topRight])
                .clipped()
        }
    }

    var contentView: some View {
        ZStack {
            VStack(alignment: .center, spacing: Constants.contentSpacings) {
                VStack(alignment: .center, spacing: Constants.headerSpacings) {
                    if let icon = presentation.icon {
                        Image(uiImage: icon)
                    }

                    if let titleText = presentation.title {
                        title(from: titleText)
                    }
                }

                if let subtitleText = presentation.subtitle {
                    subtitle(from: subtitleText)
                }

                if let additionalView = additionalView {
                    additionalView
                }

                VStack {
                    if let ctaText = presentation.cta {
                        cta(from: ctaText)
                    }

                    if let secondCtaText = presentation.secondCta {
                        secondCta(from: secondCtaText)
                    }
                }
            }
            .padding(.all, Constants.contentAllPaddings)
            .padding(.bottom, presentationStyle == .overFullScreen ? Constants.contentAllPaddings : 0)
        }
        .background(.white)
    }

    func alphaBackgroundView(from alpha: CGFloat) -> some View {
        Color(.black.withAlphaComponent(alpha))
    }

    func title(from text: String) -> some View {
        Text(text)
            .foregroundColor(.kGrayText)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    func subtitle(from text: String) -> some View {
        Text(text)
            .foregroundColor(.kGrayText)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    func cta(from text: String) -> some View {
        Button {
            presentation.action?()
        } label: {
            Text(text)
                .foregroundColor(Color(.white))
                .frame(maxWidth: .infinity)
        }
        .frame(height: Constants.ctaHeight)
        .frame(maxWidth: .infinity)
        .background(Color(.kPurple))
        .cornerRadius(Constants.ctaCornerRadius)
        .clipped()
    }

    func secondCta(from text: String) -> some View {
        Button {
            presentation.secondAction?()
        } label: {
            Text(text)
                .foregroundColor(Color(.kPurple))
                .frame(maxWidth: .infinity)
        }
        .frame(height: Constants.ctaHeight)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Constants
extension AlertView {
    private struct Constants {
        static let animationDuration = 0.2

        static let contentAllPaddings = 24.0
        static let contentCornerRadius = 16.0
        static let contentSpacings = 24.0

        static let headerSpacings = 16.0

        static let alphaBackgroundComponent = 0.9

        static let ctaHeight = 48.0
        static let ctaCornerRadius = 8.0
    }
}

#if DEBUG
struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(
            presentation: AlertViewModel(
                icon: nil,
                title: "Test title",
                subtitle: "Test subtitle message",
                cta: "Test CTA",
                action: nil
            ),
            alertStyle: .bottomSheet,
            presentationStyle: .overFullScreen
        )

        AlertView(
            presentation: AlertViewModel(
                icon: nil,
                title: "Test title",
                subtitle: "Test subtitle message",
                cta: "Test CTA",
                action: nil
            ),
            alertStyle: .dialog,
            presentationStyle: .overFullScreen
        )
    }
}
#endif
