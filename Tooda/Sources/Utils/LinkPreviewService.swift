//
//  LinkPreviewService.swift
//  Tooda
//
//  Created by Lyine on 2021/12/26.
//

import SwiftLinkPreview

struct LinkPreviewResponse {
  var title: String?
  var imageURL: String?
  var canonicalUrl: String?
  var description: String?
  
  init(response: Response) {
    self.title = response.title
    self.imageURL = response.image
    self.canonicalUrl = response.canonicalUrl
    self.description = response.description
  }
}

protocol LinkPreViewServiceType {
  func fetchMetaData(urlString: String, completion: @escaping (LinkPreviewResponse?) -> Void)
}

final class LinkPreviewService: LinkPreViewServiceType {
  let preview = SwiftLinkPreview(
    session: URLSession.shared,
    workQueue: SwiftLinkPreview.defaultWorkQueue,
    responseQueue: DispatchQueue.main,
    cache: InMemoryCache())
  
  func fetchMetaData(urlString: String, completion: @escaping (LinkPreviewResponse?) -> Void) {
    if let cache = self.preview.cache.slp_getCachedResponse(url: urlString) {
      completion(.init(response: cache))
    } else {
      self.preview.preview(urlString, onSuccess: {
        completion(.init(response: $0))
      }, onError: { _ in
        completion(nil)
      })
    }
  }
}
