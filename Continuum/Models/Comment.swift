//
//  Comment.swift
//  Continuum
//
//  Created by Chris Gottfredson on 3/31/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import Foundation

class Comment {
    let text: String
    let timestamp: Date
    weak var post: Post?
    
    init(text: String, timestamp: Date = Date(), post: Post?) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
}

extension Comment: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        text.lowercased().contains(searchTerm.lowercased())
    }
}
