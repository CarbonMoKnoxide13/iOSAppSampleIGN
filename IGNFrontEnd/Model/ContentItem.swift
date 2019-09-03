//
//  ContentItem.swift
//  IGNFrontEnd
//
//  Created by Aramis Knox on 3/11/19.
//  Copyright © 2019 Aramis Knox. All rights reserved.
//

import Foundation
import UIKit

public class ContentItem: NSObject, NSCoding {
    
    var contentType : String!
    var contentHeading : String!
    var contentDescription : String!
    var publishDate : String!
    var commentCount : Int!
    var id : String!
    var url : String!
    var thumbnail : UIImage!
    var thumbnailImageUrl: String!
    
    override init() {
        //NO OP
    }
    
    public func getContentType() -> String {
        return contentType
    }
    
    public func getThumbnail() -> UIImage {
        return thumbnail
    }
    
    public func getContentHeading() -> String {
        return contentHeading
    }
    
    public func getContentDescription() -> String {
        return contentDescription
    }
    
    public func getPublishDate() -> String {
        return publishDate
    }
    
    public func getCommentCount() -> Int {
        return commentCount
    }
    
    public func getURL() -> String {
        return url
    }
    
    public func getThumbnailImageUrl() -> String {
        return thumbnailImageUrl
    }
    
    public required init?(coder aDecoder: NSCoder) {
        if let type = aDecoder.decodeObject(forKey:"contentType") as? String{
            contentType = type
        }
        
        if let heading = aDecoder.decodeObject(forKey:"contentHeading") as? String{
            contentHeading = heading
        }
        
        if let description = aDecoder.decodeObject(forKey:"contentDescription") as? String{
            contentDescription = description
        }
        
        if let date = aDecoder.decodeObject(forKey:"publishDate") as? String{
            publishDate = date
        }
        
        if let count = aDecoder.decodeObject(forKey:"commentCount") as? Int{
            commentCount = count
        }
        
        if let identifier = aDecoder.decodeObject(forKey:"id") as? String{
            id = identifier
        }
        
        if let address = aDecoder.decodeObject(forKey:"url") as? String{
            url = address
        }
        
        if let image = aDecoder.decodeObject(forKey:"thumbnail") as? UIImage{
            thumbnail = image
        }
        
        if let name = aDecoder.decodeObject(forKey:"thumbnailImageUrl") as? String{
            thumbnailImageUrl = name
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(contentType, forKey: "contentType")
        aCoder.encode(contentHeading, forKey: "contentHeading")
        aCoder.encode(contentDescription, forKey: "contentDescription")
        aCoder.encode(publishDate, forKey:"publishDate")
        aCoder.encode(commentCount, forKey:"commentCount")
        aCoder.encode(id, forKey:"id")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(thumbnail, forKey: "thumbnail")
        aCoder.encode(thumbnailImageUrl, forKey: "thumbnailImageUrl")
    }
    
    public func calculateTimeSincePublished() -> String { //Add hours, minutes, days
        let yearAndMonth = String(describing: publishDate.prefix(7))
        let yearString = String(yearAndMonth.prefix(4))
        let year: Int? = Int(yearString)
        let monthString = yearAndMonth.suffix(2)
        let month: Int? = Int(monthString)
        let dayString = String(describing: publishDate.suffix(2))
        let day: Int? = Int(dayString)
        
        let date = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: date)
        
        let currentMonth = calendar.component(.month, from: date)
        let currentDay = calendar.component(.day, from: date)
        
        let yearDifference = currentYear - year!
        let monthDifference = currentMonth - month!
        let dayDifference = currentDay - day!
        
        var yearDisplay = ""
        if(yearDifference == 1) {
            yearDisplay = String("\(yearDifference) year")
        } else if(yearDifference > 0) {
            yearDisplay = String("\(yearDifference) years")
        }
        var monthDisplay = ""
        if(monthDifference == 1) {
            monthDisplay = String("\(monthDifference) month")
        } else if(monthDifference > 0) {
            monthDisplay = String("\(monthDifference) months")
        }
        var dayDisplay = ""
        if(dayDifference == 1) {
            dayDisplay = String("\(dayDifference) day")
        } else if(dayDifference > 0) {
            dayDisplay = String("\(dayDifference) days")
        }
        
        if(yearDisplay != "") && ((monthDisplay != "") || (dayDisplay != "")) {
            yearDisplay = yearDisplay + ", "
        }
        
        if(monthDisplay != "") && (dayDisplay != "") {
            monthDisplay = monthDisplay + ", "
        }
        
        return String("\(yearDisplay)\(monthDisplay)\(dayDisplay) ago")
    }
    
    public override var description: String {
        get{
            return "Type: \(contentType)\nHeading: \(contentHeading)\nDescription: \(contentDescription)\nPublish Date: \(publishDate)\nComment Count: \(commentCount)\nID: \(id)\nURL: \(url)\n"
        }
    }
}
