//
//  PhotosListViewModel.swift
//  testTask
//
//  Created by SashaShch on 18.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import Foundation

protocol PhotosListViewModelDelegate {
    func didStartFetchingPhotos()
    func didFinishFetchingPhotos()
}

class PhotosListViewModel {
    var delegate: PhotosListViewModelDelegate?
    
    var breed: String
    var subBreed: String?
    var photos = [String]()
    
    var url: URL? {
        get {
            return URL(string: "https://dog.ceo/api/breed/\(breed)\(subBreed != nil ? "/\(subBreed ?? "")" : "")/images")
        }
    }
    
    init(breed: String, subBreed: String?) {
        self.breed = breed
        self.subBreed = subBreed
    }
    
    func fetchPhotos() {
        delegate?.didStartFetchingPhotos()
        DispatchQueue.main.async {
            if let url = self.url {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []) {
                            if let response = jsonObj as? [String: Any] {
                                if let list = response["message"] as? [String] {
                                    for item in list {
                                        self.photos.append(item)
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.delegate?.didFinishFetchingPhotos()
                                }
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
}
