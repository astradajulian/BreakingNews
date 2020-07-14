//
//  SourceTableViewCell.swift
//  BreakingNews
//
//  Created by Julian Astrada on 06/07/2020.
//  Copyright © 2020 Julian Astrada. All rights reserved.
//

import UIKit

class HeadlineTableViewCell: UITableViewCell {

    static let identifier = "HeadlineTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    class func instanceFromNib() -> HeadlineTableViewCell {
        //We intentionally throw error here to avoid a crash elsewhere, this should never fail
        guard let instance = UINib(nibName: HeadlineTableViewCell.identifier, bundle: nil).instantiate(withOwner: nil, options: nil).first as? HeadlineTableViewCell else {
            fatalError("Error instancing HeadlineTableViewCell")
        }
        
        return instance
    }
    
    public var article: Article! {
        didSet {
            titleLabel.text = article.title
            descriptionLabel.text = article.description
            authorLabel.text = article.author
        }
    }
    
}
