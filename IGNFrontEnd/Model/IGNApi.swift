//
//  IGNApi.swift
//  IGNFrontEnd
//
//  Created by Aramis Knox on 3/8/19.
//  Copyright © 2019 Aramis Knox. All rights reserved.
//

import Foundation
import UIKit

class IGNApi {
    
    private var content = [ContentItem]()
    private var dates = [String]()
    private var slugs = [String]()
    
    init(completion: @escaping (IGNApi) -> Void) {
        retrieveJsonData(completion: completion)
    }
    
    func getDates() -> [String] {
        return dates
    }
    
    func getSlugs() -> [String] {
        return slugs
    }
    
    
    func retrieveJsonData(completion: @escaping (IGNApi) -> Void) {
        let url = URL(string: "https://api.myjson.com/bins/p6nuj") //Change URL
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let urlContent = data {
                    
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        
                        let dataResult = jsonResult["data"] as! [NSDictionary]
                        for item in dataResult {
                            let contentItem = ContentItem()
                            let contentTypeResult = item["contentType"] as! String
                            let metadataResult = item["metadata"] as! NSDictionary
                            if contentTypeResult == "articles" {
                                let headline = metadataResult["headline"] as! String
                                contentItem.contentHeading = headline
                                contentItem.contentType = "articles"
                            }
                            if contentTypeResult == "videos" {
                                let title = metadataResult["headline"] as! String
                                contentItem.contentHeading = title
                                contentItem.contentType = "videos"
                            }
                            
                            let dateResult = metadataResult["publishDate"] as! String
                            self.dates.append(dateResult)
                            
                            if let descriptionResult = metadataResult["description"] as? String{
                                contentItem.contentDescription = descriptionResult
                            } else {
                                contentItem.contentDescription = "Null description"
                            }
                            
                            let slugResult = metadataResult["slug"] as! String
                            self.slugs.append(slugResult)
                            
                            let contentId = item["contentId"] as! String
                            contentItem.id = contentId
                            let thumbnailResult = item["thumbnails"] as! [NSDictionary]
                            if (thumbnailResult.count >= 2) {
                                let mediumThumbnailResult = thumbnailResult[1] as! NSDictionary
                                let mediumThumbnailURL = mediumThumbnailResult["url"] as! String
                                contentItem.thumbnailImageUrl = mediumThumbnailURL
                            }
                            self.content.append(contentItem)
                        }
                        self.retrieveCommentCounts() {
                            self.formatDates()
                            self.createURLs()
                            completion(self)
                        }
                    } catch {
                        print("Json processing failed")
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func retrieveCommentCounts(completion: @escaping () -> Void) {
        var commentCountAccessUrl = "https://api.myjson.com/bins/huiif"
        /*for contentItem in content {
            commentCountAccessUrl.append(contentItem.id)
            commentCountAccessUrl.append(",")
        }
        commentCountAccessUrl.removeLast()*/
        let url = URL(string: commentCountAccessUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let urlContent = data {
                    
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        
                        let contentResult = jsonResult["data"] as! NSDictionary
                        
                        var count = 0
                        for contentItem in self.content {
                            let countResult = contentResult[contentItem.id] as! Int
                            self.content[count].commentCount = countResult
                            count += 1
                        }
                        /*for contentItem in contentResult {
                            let countResult = contentItem["count"] as! Int
                            self.content[count].commentCount = countResult
                            count += 1
                        }*/
                        completion()
                    } catch {
                        print("Json processing failed")
                    }
                }
            }
        }
        task.resume()
    }
    
    func formatDates() {
        var count = 0
        for date in dates {
                let editString = date.prefix(10)
                let prefixString = editString.prefix(7)
                let yearString = prefixString.prefix(4)
                let monthString = prefixString.suffix(2)
                let dayString = editString.suffix(2)
                let formattedDate = yearString + "/" + monthString + "/" + dayString
                content[count].publishDate = String(formattedDate)
                count = count + 1
        }
    }
    
    func createURLs() {
        var count = 0
        for contentItem in content {
            var contentURL = "https://www.ign.com/"
            contentURL.append(contentItem.contentType)
            contentURL.append("/")
            contentURL.append(contentItem.publishDate)
            contentURL.append("/")
            contentURL.append(slugs[count])
            contentItem.url = contentURL
            count = count + 1
        }
    }
    
    func getContentItems() -> [ContentItem] {
        return content
    }
}
