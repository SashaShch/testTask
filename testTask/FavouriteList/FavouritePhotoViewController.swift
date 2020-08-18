//
//  FavouritePhotoViewController.swift
//  testTask
//
//  Created by Рома on 17.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import UIKit

class FavouritePhotoViewController: UIPageViewController {
    
    var breedInfo = ""
    var breedPhotos = [String]()
    var pages = [UIViewController] ()
    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.dataSource = self
        print(breedPhotos)
        
        self.navigationItem.title = "Favourites"
        //self.navigationItem.backBarButtonItem?.title = "Back"
        let photos = defaults.value(forKey: breedInfo) as! [String]
        print(photos)
        breedPhotos = photos
        
        for i in self.breedPhotos {
            self.pages.append(self.getViewController(urlStr: i))
           }
        if let firstVC = self.pages.first
        {
         self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func getViewController(urlStr: String) -> PhotoPageViewController
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "PhotoPageViewController") as! PhotoPageViewController
        if let url = URL(string: urlStr) {
            vc.imageURL = url
            vc.breedInfo = breedInfo
        }
        print(urlStr)
        return vc
    }
}

extension FavouritePhotoViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard pages.count != 1 else { return nil }
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return pages.last }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard pages.count != 1 else { return nil }
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil         }
        
        return pages[nextIndex]
    }
}
