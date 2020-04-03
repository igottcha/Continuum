//
//  Post.swift
//  Continuum
//
//  Created by Chris Gottfredson on 3/31/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit.UIImage
import CloudKit

struct PostStrings {
    static let recordType = "Post"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let captionKey = "caption"
    fileprivate static let imageAssetKey = "imageAsset"
    fileprivate static let photoKey = "photo"
    fileprivate static let commentsKey = "comments"
}

class Post {
    var photoData: Data?
    let timestamp: Date
    var caption: String
    var comments: [Comment]
    let recordID: CKRecord.ID
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpeg")
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print("Error writing to temp URL \(error) : \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(photo: UIImage?, caption: String, timestamp: Date = Date(), comments: [Comment] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.caption = caption
        self.timestamp = timestamp
        self.comments = comments
        self.recordID = recordID
        self.photo = photo
    }
}

extension Post: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if caption.lowercased().contains(searchTerm.lowercased()) {
            return true
        } else {
            for comment in comments {
                if comment.matches(searchTerm: searchTerm) {
                    return true
                }
            }
        }
        return false
    }
}

extension Post {
    
    convenience init?(ckRecord: CKRecord) {
        var foundphoto: UIImage?
        if let imageAsset = ckRecord[PostStrings.imageAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: imageAsset.fileURL!)
                foundphoto = UIImage(data: data)
            } catch {
                print(error)
            }
        }
        
        guard let caption = ckRecord[PostStrings.captionKey] as? String,
            let timestamp = ckRecord[PostStrings.timestampKey] as? Date else { return nil }
       
        self.init(photo: foundphoto, caption: caption, timestamp: timestamp, comments: [], recordID: ckRecord.recordID)
    }
}

extension CKRecord {
    
    convenience init(post: Post) {
        self.init(recordType: PostStrings.recordType, recordID: post.recordID)
        self.setValuesForKeys([PostStrings.captionKey : post.caption,
                               PostStrings.timestampKey : post.timestamp])
        if post.imageAsset != nil {
            self.setValue(post.imageAsset, forKey: PostStrings.imageAssetKey)
        }
    }
}
