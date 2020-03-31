//
//  PostController.swift
//  Continuum
//
//  Created by Chris Gottfredson on 3/31/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import CloudKit
import UIKit

class PostController {
    
    //MARK: - Shared instance and singleton
    
    let shared = PostController()
    var posts: [Post] = []
    
    
    //MARK: - CRUD Functions
    
    func addComment(text: String, post: Post, completion: @escaping (Result<Comment, PostError>) -> Void) {
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
        completion(.success(comment))
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Result<Post?, PostError>) -> Void) {
        let post = Post(photo: image, caption: caption)
        self.posts.append(post)
        completion(.success(post))
    }
    
}
