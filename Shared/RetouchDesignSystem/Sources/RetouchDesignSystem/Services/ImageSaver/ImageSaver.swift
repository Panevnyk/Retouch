//
//  ImageSaver.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 11.03.2021.
//

import UIKit

@MainActor
public class ImageSaver: NSObject {
    private var continuation: CheckedContinuation<Bool, Never>?

    public func writeToPhotoAlbum(imageURLString: String) async -> Bool {
        guard let imageURL = URL(string: imageURLString) else {
            AlertHelper.show(title: "Fail to create URL", message: nil)
            return false
        }
        return await writeToPhotoAlbum(imageURL: imageURL)
    }

    public func writeToPhotoAlbum(imageURL: URL) async -> Bool {
        do {
            let image = try await downloadImage(from: imageURL)
            guard let image = image else {
                AlertHelper.show(title: "Fail to download image", message: nil)
                return false
            }
            return await writeToPhotoAlbum(image: image)
        } catch {
            return false
        }
    }

    public func writeToPhotoAlbum(image: UIImage) async -> Bool {
        await withCheckedContinuation { continuation in
            self.continuation = continuation
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
        }
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            AlertHelper.show(title: "ImageSaver saveError: \(String(describing: error))", message: nil)
        }
        continuation?.resume(returning: error == nil)
        continuation = nil
    }

    private func getData(from url: URL) async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(from: url)
    }

    private func downloadImage(from url: URL) async throws -> UIImage? {
        let (data, _) = try await getData(from: url)

        return await MainActor.run {
            UIImage(data: data)
        }
    }
}
