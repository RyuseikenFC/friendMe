//
//  CommentPostVC.swift
//  FriendMe
//
//  Created by Steven on 4/1/18.
//  Copyright © 2018 Steven. All rights reserved.
//

import UIKit
import Firebase

class CommentPostVC: UIViewController {

    @IBOutlet weak var postText: UITextView!
    var passedPostId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func post(_ sender: AnyObject){
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
            let data = snapshot.value as! Dictionary<String, AnyObject>
            let username = data["username"]
            let userImg = data["userImg"]
            
            let post: Dictionary<String, AnyObject> = [
                "username": username as AnyObject,
                "userImg": userImg as AnyObject,
                "postText": self.postText.text as AnyObject
            ]
            
            let firebasePost = Database.database().reference().child("textPosts").child(self.passedPostId).child("comments").childByAutoId()
            firebasePost.setValue(post)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}
