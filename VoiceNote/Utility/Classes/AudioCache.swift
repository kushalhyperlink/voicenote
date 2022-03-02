//
//  AudioCache.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import Foundation

class AudioCache {
    typealias AudioHandler = ((URL?, Error?) -> Void)
    
    static let shared = AudioCache()
    
    private func cachedAudio(for name: String) -> URL? {
        
        let cachesFolderURL = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let audioFileURL = cachesFolderURL!.appendingPathComponent(name)
        
        if FileManager.default.fileExists(atPath: audioFileURL.path) {
            return audioFileURL
        }
        return nil
    }
    
    func load(url: URL, completion: @escaping AudioHandler) {
        DispatchQueue.global(qos: .userInitiated).async {
            // If there is cached url, return cached url.
            if let cachedURL = self.cachedAudio(for: url.lastPathComponent) {
                completion(cachedURL, nil)
                return
            }
            
            let task = URLSession.shared.downloadTask(with: url) { downloadedURL, urlResponse, error in
                guard let downloadedURL = downloadedURL else { return }
                
                let cachesFolderURL = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let audioFileURL = cachesFolderURL!.appendingPathComponent(url.lastPathComponent)
                try? FileManager.default.copyItem(at: downloadedURL, to: audioFileURL)
                
                completion(audioFileURL, nil)
            }
            task.resume()
        }
    }
}
