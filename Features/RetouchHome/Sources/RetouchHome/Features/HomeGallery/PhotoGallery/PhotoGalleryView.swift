//
//  PhotoGalleryView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 18.10.2022.
//

import SwiftUI
import RetouchUtils
import RetouchDesignSystem

public struct PhotoGalleryView: View {
    // MARK: - Properties
    @ObservedObject private var viewModel: PhotoGalleryViewModel
    
    // MARK: - Inits
    public init(viewModel: PhotoGalleryViewModel) {
        self.viewModel = viewModel
    }
    
    public func didSelectOrder() {
        viewModel.didSelectOrder()
    }
    
    // MARK: - UI
    public var body: some View {
        bodyView
            .onAppear(perform: viewModel.viewOnAppear)
    }
    
    var bodyView: some View {
        VStack(spacing: 0) {
            headerView
            
            VStack(spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    ScrollableImage(image: viewModel.scaledImage)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    OrderButton(action: viewModel.order)
                        .isAvailable(viewModel.isOrderAvailable)
                        .offset(x: -16, y: -16)
                }
                
                GroupsAndTagsView(retouchGroups: viewModel.retouchGroups,
                                  openGroupIndex: $viewModel.openGroupIndex,
                                  openTagIndex: $viewModel.openTagIndex)
            }
            .animation(.default, value: viewModel.animationValue)
        }
        .background(Color.kBackground)
        .overlay {
            processingPurchaseView
                .isHidden(viewModel.isPurchaseBlurViewHidden)
        }
    }
    
    var headerView: some View {
        HStack(spacing: 16) {
            BackSwiftButton(action: viewModel.didSelectBack)
            
            HStack {
                Text("Retouch cost:")
                    .font(.kPlainText)
                
                PriceSwiftView(price: $viewModel.retouchCost)
                
                Spacer()

                BalanceSwiftView(action: viewModel.didSelectBalance)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], 16)
        .zIndex(100)
    }
    
    var processingPurchaseView: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.8)

            VStack(spacing: 20) {
                Text("      Processing purchase ...")
                    .font(.kTitleBigText)
                    .foregroundColor(.white)

                Image("icPhotoRetouchingWaiting1", bundle: Bundle.designSystem)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
}
