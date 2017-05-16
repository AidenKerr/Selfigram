//
//  Post.swift
//  Selfigram
//
//  Created by lighthouselabs on 2017-04-19.
//  Copyright © 2017 lighthouselabs. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Post: PFObject, PFSubclassing {
    @NSManaged var image: PFFile
    @NSManaged var user: PFUser
    @NSManaged var comment: String
    
    var likes: PFRelation<PFObject>! {
        return relation(forKey: "likes")
    }
    
    convenience init(image: PFFile, user: PFUser, comment: String) {
        self.init()
        self.image = image
        self.user = user
        self.comment = comment
    }
    
    static func parseClassName() -> String {
        return "Post"
    }
}
