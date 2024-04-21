//
//  ImageLoader.swift
//  iOS Assignment
//
//  Created by Kishan on 21/04/24.
//

import Foundation
import UIKit

class ImageLoader {
    
    // Memory cache
    private var imageCache = NSCache<NSString, UIImage>()
    
    // Disk cache directory
    private let diskCacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("ImageCache")
    
    // Fetch image URLs from API
    func fetchImageURLs(completion: @escaping (Result<[ImageModel], Error>) -> Void) {
        guard let url = URL(string: "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        print(url)
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NetworkError.unknownError))
                return
            }
            
            do {
                let json = try JSONDecoder().decode([ImageModel].self, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Load image from URL with caching
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        // Check memory cache
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        // Check disk cache
        if let cachedImage = loadFromDiskCache(url: url) {
            imageCache.setObject(cachedImage, forKey: url.absoluteString as NSString)
            completion(.success(cachedImage))
            return
        }
        
        // If not cached, fetch from network
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NetworkError.unknownError))
                return
            }
            
            if let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                self.saveToDiskCache(data: data, url: url)
                completion(.success(image))
            } else {
                completion(.failure(NetworkError.invalidImageData))
            }
        }.resume()
    }
    
    // Load image from disk cache
    private func loadFromDiskCache(url: URL) -> UIImage? {
        let fileURL = diskCacheDirectory.appendingPathComponent(url.lastPathComponent)
        if let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    // Save image to disk cache
    private func saveToDiskCache(data: Data, url: URL) {
        let fileURL = diskCacheDirectory.appendingPathComponent(url.lastPathComponent)
        do {
            try data.write(to: fileURL)
        } catch {
            print("Failed to save image to disk cache:", error)
        }
    }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case invalidImageData
        case unknownError
    }
}




