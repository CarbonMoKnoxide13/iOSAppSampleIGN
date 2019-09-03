//
//  Extensions.swift
//  IGNFrontEnd
//
//  Created by Aramis Knox on 3/24/19.
//  Copyright © 2019 Aramis Knox. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

let thumbnailCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingUrlString(urlString: String) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, responses, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            if let imageFromCache = thumbnailCache.object(forKey: urlString as AnyObject) as? UIImage {
                DispatchQueue.main.async {
                    self.image = imageFromCache
                    return
                }
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                thumbnailCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                self.image = imageToCache
            }
        }).resume()
    }
}

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

