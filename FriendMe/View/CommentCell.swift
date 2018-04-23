//
//  CommentCell.swift
//  FriendMe
//
//  Created by Steven on 4/1/18.
//  Copyright © 2018 Steven. All rights reserved.
//

import UIKit
import Firebase

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        postText.text = ""
    }

    var post: Post!
    
    func configCell(post: Post) {
        self.post = post
        self.username.text = post.username
        self.postText.text = post.postText
        
        let ref = Storage.storage().reference(forURL: post.userImg)
        ref.getData(maxSize: 100000000, completion: {(data, error) in
            if error != nil{
                print("coudlnt load img")
            } else {
                if let imgData = data {
                    if let img = UIImage(data: imgData){
                        self.userImg.image = img
                    }
                }
            }
            
        })
        
    }

}
