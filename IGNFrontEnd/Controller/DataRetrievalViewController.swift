//
//  DataRetrievalViewController.swift
//  IGNFrontEnd
//
//  Created by Aramis Knox on 3/6/19.
//  Copyright © 2019 Aramis Knox. All rights reserved.
//

import UIKit
import WebKit

class DataRetrievalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, WKUIDelegate, WKNavigationDelegate {
    
    var selectedCategory = 0
    
    var webView : WKWebView!
    
    var tableView : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(ContentCell.self, forCellReuseIdentifier: "cellId")
        return tv
    }()
    
    var dataFinishedLoading = false
    
    let articlesCellIdentifier = "articles"
    
    var articles : [ContentItem] = []
    var videos : [ContentItem] = []
    
    var readWatchArray = ["Read", "Watch"]
    
    var slideBar : SlideBar = {
        let sb = SlideBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.red
        slideBar.collectionView.delegate = self
        
        do{
            try retrieveAPIContent()
        } catch {
            print("API is down")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = indexPath.row
        tableView.reloadData()
        let x = CGFloat(indexPath.item) * slideBar.frame.width / 2
        slideBar.horizontalBarLeftAnchorConstraint?.constant = x
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {self.slideBar.layoutIfNeeded()}, completion: nil)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (slideBar.frame.width / 2), height: slideBar.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let allContent = [articles, videos]
        return allContent[selectedCategory].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ContentCell
        let allContent = [articles, videos]
        cell.contentItem = allContent[selectedCategory][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let allContent = [articles, videos]
        if let article = allContent[selectedCategory][indexPath.row] as? ContentItem {
            let approximateWidthOfContent = view.frame.width
            let size = CGSize(width: approximateWidthOfContent, height: 1000)
            
            let headingAttributes = [NSAttributedStringKey.font: UIFont(name: "Avenir-Black", size: 24)]
            let descriptionAttributes = [NSAttributedStringKey.font: UIFont(name: "Avenir", size: 17)]
            let publishDateAttributes = [NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 17)]
            
            let estimatedDateFrame = NSString(string: article.getPublishDate()).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: publishDateAttributes, context: nil)
            let estimatedHeadingFrame = NSString(string: article.getContentHeading()).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: headingAttributes, context: nil)
            let estimatedDescriptionFrame = NSString(string: article.getContentDescription()).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: descriptionAttributes, context: nil)
            let estimatedReadFrame = NSString(string: "Read").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: publishDateAttributes, context: nil)
            
            let totalEstimatedHeight = estimatedDateFrame.height + estimatedHeadingFrame.height + estimatedDescriptionFrame.height + estimatedReadFrame.height + 316
            
            return totalEstimatedHeight
        }
        
        return 450
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let allContent = [articles, videos]
        displayWebViewForItem(contentItem: allContent[selectedCategory][indexPath.row])
    }
    
    func displayWebViewForItem(contentItem: ContentItem) {
        let webViewController = DisplayWebViewController()
        webViewController.contentUrl = URL(string: contentItem.getURL())
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    private func setupSlideBar() {
        view.addSubview(slideBar)
        view.addSubview(tableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: slideBar)
        view.addConstraintsWithFormat(format: "V:|[v0(55)]", views: slideBar)
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: slideBar, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: slideBar, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: slideBar, attribute: .right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    func retrieveAPIContent() throws {
        _ = IGNApi(completion: {dataRetriever in
            let content = dataRetriever.getContentItems()
            for item in content {
                if (item.getContentType() == "articles") {
                    self.articles.append(item)
                }
                else{
                    self.videos.append(item)
                }
            }
            self.dataFinishedLoading = true
            self.reloadDataOnMainThread()
        })
    }
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.setupSlideBar()
        }
    }
}
