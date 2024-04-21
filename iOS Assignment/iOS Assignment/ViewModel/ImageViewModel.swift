//
//  ImageViewModel.swift
//  iOS Assignment
//
//  Created by Kishan on 21/04/24.
//

import Foundation
import UIKit

class ImageViewModel {
    private let imageLoader = ImageLoader()
    var imageURLs: [URL] = []
    var imageURLsFetched: (([URL]) -> Void)?
    var onError: ((Error) -> Void)?
        
        // Fetch image URLs from API
        func fetchImageURLData() {
            imageLoader.fetchImageURLs { [weak self] result in
                switch result {
                case .success(let json):
                    var urls: [URL] = []
                    for imageModel in json {
                        let thumbnail = imageModel.thumbnail
                        let domain = thumbnail?.domain
                        let basePath = thumbnail?.basePath
                        let key = thumbnail?.key
                        if let domain = domain, let basePath = basePath, let key = key {
                            let imageURL = domain + "/" + basePath + "/0/" + key
                            if let url = URL(string: imageURL) {
                                urls.append(url)
                            }
                        }
                    }
                    self?.imageURLs = urls
                    self?.imageURLsFetched?(urls)
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
//    }

//    private let imageLoader = ImageLoader()
//    var imageURLs: [URL] = []
//
//
//    // Closure to update UI with fetched image URLs
//    var imageURLsFetched: (([URL]) -> Void)?
//    // Closure to update UI with loaded images
//    var imageLoaded: ((UIImage) -> Void)?
//    // Closure to handle error
//    var onError: ((Error) -> Void)?
//
//    // Fetch image URLs from API
//    func fetchImageURLData() {
//        imageLoader.fetchImageURLs { [weak self] result in
//            switch result {
//            case .success(let urls):
//                self?.imageURLs = urls
//                self?.imageURLsFetched?(urls)
//            case .failure(let error):
//                self?.onError?(error)
//            }
//        }
//    }
    
    // Load image from URL
//    func loadImage(at index: Int) -> URL? {
//        guard index < imageURLs.count else { return nil }
//        let url = imageURLs[index]
//        imageLoader.loadImage(from: url) { [weak self] result in
//            switch result {
//            case .success(let image):
//                self?.imageLoaded?(image)
//            case .failure(let error):
//                self?.onError?(error)
//            }
//        }
//        return imageURLs[index]
//    }

}
