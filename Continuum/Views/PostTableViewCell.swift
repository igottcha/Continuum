//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Chris Gottfredson on 3/31/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    //MARK: - Properties
    
    var post: Post? {
        didSet {
            self.updateViews()
        }
    }
    
    func updateViews() {
        guard let post = post else { return }
        photoImageView.image = post.photo
        captionLabel.text = post.caption
        commentsLabel.text = "Comments: \(post.comments.count)"
    }
}
