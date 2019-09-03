//Comment Test

import UIKit

class ContentCell: UITableViewCell {
    
    var contentItem :ContentItem? {
        didSet{
            publishDateView.text = contentItem?.calculateTimeSincePublished()
            headingView.text = contentItem?.getContentHeading()
            thumbnailImageView.loadImageUsingUrlString(urlString: (contentItem?.thumbnailImageUrl)!)
            //thumbnailImageView.image = contentItem?.getThumbnail()
            descriptionView.text = contentItem?.getContentDescription()
            if(contentItem!.contentType == "articles"){
                readView.text = "Read"
            } else{
                readView.text = "Watch"
            }
            commentCountView.text = String(describing: contentItem!.getCommentCount())
            //Top Constraints
            addConstraint(NSLayoutConstraint(item: publishDateView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 16))
            addConstraint(NSLayoutConstraint(item: headingView, attribute: .top, relatedBy: .equal, toItem: publishDateView, attribute: .bottom, multiplier: 1, constant: 8))
            addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .top, relatedBy: .equal, toItem: headingView, attribute: .bottom, multiplier: 1, constant: 8))
            addConstraint(NSLayoutConstraint(item: descriptionView, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
            addConstraint(NSLayoutConstraint(item: readView, attribute: .top, relatedBy: .equal, toItem: descriptionView, attribute: .bottom, multiplier: 1, constant: 8))
            addConstraint(NSLayoutConstraint(item: commentView, attribute: .top, relatedBy: .equal, toItem: descriptionView, attribute: .bottom, multiplier: 1, constant: 8))
            addConstraint(NSLayoutConstraint(item: commentCountView, attribute: .top, relatedBy: .equal, toItem: descriptionView, attribute: .bottom, multiplier: 1, constant: 8))
            
            //Left Constraints
            addConstraint(NSLayoutConstraint(item: publishDateView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 16))
            addConstraint(NSLayoutConstraint(item: headingView, attribute: .left, relatedBy: .equal, toItem: publishDateView, attribute: .left, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .left, relatedBy: .equal, toItem: headingView, attribute: .left, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: descriptionView, attribute: .left, relatedBy: .equal, toItem: thumbnailImageView, attribute: .left, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: readView, attribute: .left, relatedBy: .equal, toItem: descriptionView, attribute: .left, multiplier: 1, constant: 0))
            
            //Right Constraints
            addConstraint(NSLayoutConstraint(item: publishDateView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -16))
            addConstraint(NSLayoutConstraint(item: headingView, attribute: .right, relatedBy: .equal, toItem: publishDateView, attribute: .right, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: descriptionView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .right, relatedBy: .equal, toItem: headingView, attribute: .right, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: commentCountView, attribute: .right, relatedBy: .equal, toItem: headingView, attribute: .right, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: commentView, attribute: .right, relatedBy: .equal, toItem: commentCountView, attribute: .left, multiplier: 1, constant: -8))
            //3788C8
            //Height Constraints
            addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: (UIScreen.main.bounds.width - 32) * 0.56))
            
            //Width Constraints
            addConstraint(NSLayoutConstraint(item: headingView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: UIScreen.main.bounds.width - 32))
        }
    }
    
    func getThumbnailData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let publishDateView: UILabel = {
        let label = UILabel()
        label.text = "Tester"
        label.textColor = UIColor.red
        label.font = UIFont(name: "Avenir-Heavy", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let headingView: UILabel = {
        let view = UILabel()
        view.text = "Tester"
        view.font = UIFont(name: "Avenir-Black", size: 24)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        view.sizeToFit()
        return view
    }()
    
    let descriptionView: UITextView = {
        let view = UITextView()
        view.text = "Tester"
        view.font = UIFont(name:"Avenir", size: 17)
        view.textColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
        return view
    }()
    
    let readView: UILabel = {
        let view = UILabel()
        view.text = "Read"
        view.font = UIFont(name: "Avenir-Black", size: 17)
        view.textColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        view.sizeToFit()
        return view
    }()
    
    let commentView: UILabel = {
        let view = UILabel()
        view.text = "Comment"
        view.font = UIFont(name: "Avenir-Black", size: 17)
        view.textColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        view.sizeToFit()
        return view
    }()
    
    let commentCountView: UILabel = {
        let view = UILabel()
        view.text = "Null"
        view.font = UIFont(name: "Avenir-Black", size: 17)
        view.textColor = UIColor(red: 55.0 / 255.0, green: 136.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        view.sizeToFit()
        return view
    }()
    
    func setupViews() {
        
        addSubview(thumbnailImageView)
        addSubview(publishDateView)
        addSubview(headingView)
        addSubview(descriptionView)
        addSubview(readView)
        addSubview(commentView)
        addSubview(commentCountView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
