//
//  BreedPhotoViewController.swift
//  testTask
//
//  Created by Рома on 16.08.2020.
//  Copyright © 2020 SashaShch. All rights reserved.
//

import UIKit

class BreedPhotoViewController: UIPageViewController {
    
    var breedInfo = ""
    var breedTitle = ""
    var breedPhotos = [String]()
    
    var pages = [UIViewController] ()
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.dataSource = self
        
        self.navigationItem.title = breedTitle
        //self.navigationItem.backBarButtonItem?.title = "Back"
        let rightButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(rightButtonAction))
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        
        let urlStr = "https://dog.ceo/api/breed/\(breedInfo)/images"
        print(urlStr)
        
        if let url = URL(string: urlStr) {
            
            DispatchQueue.main.async {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []) {
                            if let response = jsonObj as? [String: Any] {
                                if let list = response["message"] as? [String] {
                                    DispatchQueue.main.async {
                                        for item in list {
                                            self.breedPhotos.append(item)
                                        }
                                        for i in self.breedPhotos {
                                            self.pages.append(self.getViewController(urlStr: i))
                                        }
                                        
                                        if let firstVC = self.pages.first {
                                            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                task.resume()
                
            }
            
            
        }
        
        
    }
    
    @objc func rightButtonAction() {
        breedPhotos[currentIndex].share()
    }
    
    func getViewController(urlStr: String) -> PhotoPageViewController
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "PhotoPageViewController") as! PhotoPageViewController
        if let url = URL(string: urlStr) {
            vc.imageURL = url
            vc.breedInfo = breedTitle
        }
        return vc
    }
}

extension BreedPhotoViewController: UIPageViewControllerDataSource
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


