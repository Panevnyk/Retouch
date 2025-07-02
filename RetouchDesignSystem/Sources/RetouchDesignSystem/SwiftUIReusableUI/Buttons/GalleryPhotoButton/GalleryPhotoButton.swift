//
//  GalleryPhotoButton.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk  on 23.08.2023.
//

import SwiftUI

public struct GalleryPhotoButton: View {
    public var galleryAction: (() -> Void)?
    public var cameraAction: (() -> Void)?
    
    public init(
        galleryAction: (() -> Void)?,
        cameraAction: (() -> Void)?
    ) {
        self.galleryAction = galleryAction
        self.cameraAction = cameraAction
    }
    
    public var body: some View {
        HStack {
            Button {
                galleryAction?()
            } label: {
                ZStack {
                    Image("icGallery", bundle: .module)
                        .frame(width: 24, height: 24)
                }
            }
            
            Rectangle()
                .frame(width: 1, height: 24)
                .foregroundColor(Color.white)
            
            Button {
                cameraAction?()
            } label: {
                Image("icCamera", bundle: .module)
                    .frame(width: 24, height: 24)
            }
        }
        .frame(width: 96, height: 36)
        .background(Color.kPurple)
        .cornerRadius(18)
    }
}

struct GalleryPhotoButton_Previews: PreviewProvider {
    static var previews: some View {
        GalleryPhotoButton(
            galleryAction: nil,
            cameraAction: nil
        )
    }
}
