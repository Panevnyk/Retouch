//
//  NotificationBannerView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk  on 23.08.2023.
//

import SwiftUI

struct NotificationBannerView: View {
    private let viewModel: NotificationBannerViewModel
    
    init(viewModel: NotificationBannerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                if let indicatorImage = viewModel.indicatorImage {
                    Image(uiImage: indicatorImage)
                        .frame(width: 24, height: 24)
                    
                    Text(viewModel.notificationTitle)
                        .foregroundColor(.black)
                        .font(.kTitleBigBoldText)
                    
                    Spacer()
                    
                    Button {
                        viewModel.closeAction?()
                    } label: {
                        Image("icCloseGray", bundle: .designSystem)
                            .frame(width: 40, height: 40)
                    }
                }
            }
            
            if let attrNotificationDescription = viewModel.attrNotificationDescription {
                Text(attrNotificationDescription)
                    .foregroundColor(.black)
                    .font(.kPlainText)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 12)
                
            } else if let notificationDescription = viewModel.notificationDescription {
                Text(notificationDescription)
                    .foregroundColor(.black)
                    .font(.kPlainText)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 12)
            }
        }
        .padding(.all, 8)
        .background(.white)
    }
}

struct NotificationBannerView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationBannerView(
            viewModel: NotificationBannerViewModel(
                notificationTitle: "Title",
                notificationDescription: "Description",
                indicatorImage: nil,
                closeAction: nil
            )
        )
    }
}
