//
//  LinkPreviewService.swift
//  Tooda
//
//  Created by Lyine on 2021/12/26.
//

import SwiftLinkPreview

protocol LinkPreViewServiceType {
  func fetchMetaData(urlString: String, completion: @escaping (Response?) -> Void)
}

final class LinkPreviewService: LinkPreViewServiceType {
  let preview = SwiftLinkPreview(
    session: URLSession.shared,
    workQueue: SwiftLinkPreview.defaultWorkQueue,
    responseQueue: DispatchQueue.main,
    cache: InMemoryCache())
  
  func fetchMetaData(urlString: String, completion: @escaping (Response?) -> Void) {
    if let cache = self.preview.cache.slp_getCachedResponse(url: urlString) {
      completion(cache)
    } else {
      self.preview.preview(urlString, onSuccess: {
        completion($0)
      }, onError: { _ in
        completion(nil)
      })
    }
  }
}
