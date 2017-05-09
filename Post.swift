//
//  Post.swift
//  Selfigram
//
//  Created by lighthouselabs on 2017-04-19.
//  Copyright © 2017 lighthouselabs. All rights reserved.
//

import Foundation
import UIKit

class Post {
    let imageURL: URL
    let user: User
    let comment: String
    
    init(imageURL: URL, user: User, comment: String) {
        self.imageURL = imageURL
        self.user = user
        self.comment = comment
    }
}
