//
//  PlaceholderView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk  on 27.08.2023.
//

import UIKit
import SwiftUI

@MainActor
public class PlaceholderViewModel: Sendable {
    let image: UIImage?
    let title: String
    let subtitle: String
    let actionTitle: String?
    let action: (@MainActor @Sendable () -> ())?
    
    // MARK: - Init
    public init(
        image: UIImage?,
        title: String,
        subtitle: String,
        actionTitle: String? = nil,
        action: (@MainActor @Sendable () -> ())? = nil
    ) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }
}

public struct PlaceholderView: View {
    // MARK: - Properties
    private let viewModel: PlaceholderViewModel
    
    // MARK: - Init
    public init(
        viewModel: PlaceholderViewModel
    ) {
        self.viewModel = viewModel
    }
    
    // MARK: - UI
    public var body: some View {
        bodyView
            .background(.white)
    }
    
    private var bodyView: some View {
        VStack(spacing: 32.0) {
            if let image = viewModel.image {
                Image(uiImage: image)
            }
            
            VStack(spacing: 16.0) {
                Text(viewModel.title)
                    .font(.kBigTitleText)
                    .foregroundColor(.kTextDarkGray)
                    .multilineTextAlignment(.center)
                
                Text(viewModel.subtitle)
                    .font(.kTitleBigText)
                    .foregroundColor(.kGrayText)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = viewModel.actionTitle {
                HStack {
                    Spacer()
                    
                    MainButton(
                        title: actionTitle,
                        action: viewModel.action
                    )
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView(
            viewModel: PlaceholderViewModel (
                image: UIImage(named: "img", in: .module, compatibleWith: nil),
                title: "Title",
                subtitle: "Subtitle"
            )
        )
    }
}
