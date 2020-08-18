//
//  PhotoPageViewController.swift
//  testTask
//
//  Created by SashaShch on 16.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import UIKit

class PhotoPageViewController: UIViewController {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    public var imageURL: URL?
    var breedInfo = ""
    var favorites = [String]()
    var breeds = [String]()
    let defaults = UserDefaults.standard
    
    private var isLikeButtonPressed: Bool {
        get {
            guard let url = imageURL else {return false}
            return favorites.contains(url.absoluteString)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = imageURL {
            DispatchQueue.main.async {
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    self.photoImage.image = image
                }
            }
        }
        
        
//        let rightButtonItem = UIBarButtonItem(title: "test", style: .plain, target: self, action: #selector(rightButtonAction))
//        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favorites = defaults.value(forKey: breedInfo) as? [String] ?? []
        if isLikeButtonPressed == true {
            likeButton.setImage(UIImage(named: "heart-fill"), for: .normal)
        } else { likeButton.setImage(UIImage(named: "heart"), for: .normal)}
        
    }
    
//    @objc func rightButtonAction() {
//        "Data to share".share()
//    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        guard let url = imageURL else {return}
        if self.isLikeButtonPressed {
            likeButton.setImage(UIImage(named: "heart"), for: .normal)
            let index = favorites.firstIndex(of: url.absoluteString)
            if index != nil {
                favorites.remove(at: index!)
            }
        } else {
            favorites.append(url.absoluteString)
            likeButton.setImage(UIImage(named: "heart-fill"), for: .normal)
        }
        defaults.set(favorites, forKey: breedInfo)
        print(favorites)
    }
    
}

extension UIApplication {
    class var topViewController: UIViewController? { return getTopViewController() }
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController { return getTopViewController(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController { return getTopViewController(base: selected) }
        }
        if let presented = base?.presentedViewController { return getTopViewController(base: presented) }
        return base
    }
}

extension Hashable {
    func share() {
        let activity = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        UIApplication.topViewController?.present(activity, animated: true, completion: nil)
    }
}

