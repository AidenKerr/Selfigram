//
//  SelfieCell.swift
//  Selfigram
//
//  Created by lighthouselabs on 2017-04-26.
//  Copyright © 2017 lighthouselabs. All rights reserved.
//

import UIKit
import Parse

class SelfieCell: UITableViewCell {

    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var heartAnimationView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    var post:Post? {
        didSet {
            if let post = post {
                
                //prevent flickering
                selfieImageView.image = nil
                
                let imageFile = post.image
                imageFile.getDataInBackground(block: { (data, error) -> Void in
                    if let data = data {
                        let image = UIImage(data: data)
                        self.selfieImageView.image = image
                    }
                })
                
                usernameLabel.text = post.user.username
                commentLabel.text = post.comment
                
                likeButton.isSelected = false
                
                let query = post.likes.query()
                query.findObjectsInBackground(block: { (users, error) -> Void in
                    
                    if let users = users as? [PFUser] {
                        for user in users {
                            if user.objectId == PFUser.current()?.objectId {
                                self.likeButton.isSelected = true
                            }
                        }
                    }
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func likeButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if let post = post,
            let user = PFUser.current() {
            
            if sender.isSelected {
                post.likes.add(user)
                
                post.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        print("likes from user successfully saved")
                        
                        let activity = Activity(type: "like", post: post, user: user)
                        activity.saveInBackground(block: { (success, error) -> Void in
                            print("activity saved")
                        })
                    } else {
                        print("error is \(error!)")
                    }
                })
            } else {
                post.likes.remove(user)
                
                post.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        print("unlike successful")
                        
                        if let activityQuery = Activity.query(){
                            activityQuery.whereKey("post", equalTo: post)
                            activityQuery.whereKey("user", equalTo: user)
                            activityQuery.whereKey("type", equalTo: "like")
                            activityQuery.findObjectsInBackground(block: { (activities, error) -> Void in
                                if let activities = activities {
                                    for activity in activities {
                                        activity.deleteInBackground(block: { (success, error) in
                                            print("activity deleted")
                                        })
                                    }
                                }
                            })
                            
                        }
                    } else {
                        print("error unliking: \(error!)")
                    }
                })
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tapAnimation() {
        heartAnimationView.isHidden = false
        heartAnimationView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: { () -> Void in
            self.heartAnimationView.transform = CGAffineTransform(scaleX: 3, y: 3)
        }) { (success) -> Void in
            self.heartAnimationView.isHidden = true
        }
        
        likeButtonClicked(likeButton)
    }

}
