//
//  Comment.swift
//  Continuum
//
//  Created by Chris Gottfredson on 3/31/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import CloudKit

struct CommentStrings {
    static let recordType = "Comment"
    fileprivate static let textKey = "text"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let postReferenceKey = "postReference"
    
}

class Comment {
    var text: String
    let timestamp: Date
    let recordID: CKRecord.ID
    weak var post: Post?
    
    var postReference: CKRecord.Reference? {
        guard let post = post else { return nil }
        return CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
    }
    
    init(text: String, timestamp: Date = Date(), post: Post?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
        self.recordID = recordID
    }
}

extension Comment: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        text.lowercased().contains(searchTerm.lowercased())
    }
}

extension Comment {
    
    convenience init?(ckRecord: CKRecord, post: Post) {
        
        guard let text = ckRecord[CommentStrings.textKey] as? String,
        let timestamp = ckRecord[CommentStrings.timestampKey] as? Date else { return nil }
     
        self.init(text: text, timestamp: timestamp, post: post, recordID: ckRecord.recordID)
    }
}

extension CKRecord {
    
    convenience init(comment: Comment) {
        self.init(recordType: CommentStrings.recordType, recordID: comment.recordID)
        self.setValuesForKeys([CommentStrings.textKey : comment.text,
                               CommentStrings.timestampKey : comment.timestamp])
        
        if let reference = comment.postReference {
            self.setValue(reference, forKey: CommentStrings.postReferenceKey)
        }
    }
}
