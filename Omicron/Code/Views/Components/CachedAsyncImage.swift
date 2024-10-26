//
//  CachedAsyncImage.swift
//  Omicron
//
//  Created by Beni Kis on 10/09/2024.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    @State private var cachedImage: UIImage?
    @State private var isLoading = false
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder
    }
        
    var body: some View {
        Group {
            if let image = cachedImage {
                content(Image(uiImage: image))
            } else {
                AsyncImage(
                    url: url,
                    scale: scale,
                    transaction: transaction
                ) { phase in
                    switch phase {
                    case .empty:
                        placeholder()
                    case .success(let image):
                        cacheAndRender(image: image)
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .onAppear(perform: loadCachedImage)
    }
        
    private func loadCachedImage() {
        if self.cachedImage == nil {
            isLoading = true
            if let cached = ImageCache.shared.get(forKey: url.absoluteString) {
                self.cachedImage = cached
                isLoading = false
            }
        }
    }
        
    @MainActor
    private func cacheAndRender(image: Image) -> some View {
        let uiImage = image.asUIImage()
        if let image = uiImage {
            DispatchQueue.main.async {
                ImageCache.shared.set(image, forKey: url.absoluteString)
                self.cachedImage = uiImage
                self.isLoading = false
            }
        }
        
        return content(image)
    }
}



#Preview {
    CachedAsyncImage(url: URL(string: "https://artworks.thetvdb.com/banners/posters/78804-52.jpg")!) {
        $0.resizable()
            .scaledToFit()
    } placeholder: {
        ProgressView()
    }
}
