//
//  CommentsVC.swift
//  FriendMe
//
//  Created by Steven on 4/1/18.
//  Copyright © 2018 Steven. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UITableViewController {

    var post: Post!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getComments()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        switch segue.identifier {
        case "toCommenPost"?:
            let destination = segue.destination as! CommentPostVC
            destination.passedPostId = self.post.postKey
        default:
            return
        }
        
    }
    
    func getComments(){
        Database.database().reference().child("textPosts").child(post.postKey).child("comments").observeSingleEvent(of: .value) {(snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else{return}
            self.posts.removeAll()
            for data in snapshot.reversed(){
                guard let postDict = data.value as? Dictionary<String, AnyObject> else{return}
                let post = Post(postKey: data.key, postData: postDict)
                self.posts.append(post)
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else { return UITableViewCell()}
        cell.configCell(post: posts[indexPath.row])

        // Configure the cell...

        return cell
    }
    
    @IBAction func goToComment(_ sender: AnyObject){
        performSegue(withIdentifier: "toCommentPost", sender: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
