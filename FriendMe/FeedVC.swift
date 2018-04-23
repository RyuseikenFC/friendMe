//
//  FeedVC.swift
//  FriendMe
//
//  Created by Steven on 4/1/18.
//  Copyright © 2018 Steven. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UITableViewController {

    var currentUserImageUrl: String!
    var posts = [Post]()
    var selectedPost: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersData()
        getPosts()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
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
        switch segue.identifier{
        case "toComments"?:
            let destination = segue.destination as! CommentsVC
            destination.post = self.selectedPost
        default:
            return
        }
    }

    @objc func signOut(_ sender: AnyObject){
        KeychainWrapper.standard.removeObject(forKey: "uid")
        do{
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("error signing out: %@", signOutError)
        }
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source

    func getUsersData(){
        let uid = KeychainWrapper.standard.string(forKey: "uid")
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value){(snapshot) in
            if let postDict = snapshot.value as? [String: AnyObject]{
                self.currentUserImageUrl = snapshot["userImg"] as! String
                self.tableView.reloadData()
            }
        }
    }
    
    func getPosts(){
        Database.database().reference().child("textPosts").observeSingleEvent(of: .value){(snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            self.posts.removeAll()
            for data in snapshot.reversed(){
                guard let postDict = data.value as? Dictionary<String, AnyObject> else{return}
                let post = Post(postKey: data.key, postData: postDict)
                self.posts.append(post)
            }
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return 1 + posts.count
        
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ShareSomethingCell") as? ShareSomethingCell {
                if currentUserImageUrl != nil {
                    
                    cell.configCell(userImgUrl: currentUserImageUrl)
                    cell.shareBtn.addTarget(self, action: #selector(toCreatePost), for: .touchUpInside)
                }
                return cell
            }

        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostCell else {return  UITableViewCell()}
        cell.commenBtn.addTarget(self, action: #selector(toComments(_:)), for: .touchUpInside)
        cell.configCell(post: posts[indexPath.row-1])
        return cell
    }
    
    @objc func toCreatePost(_ sender: AnyObject){
        performSegue(withIdentifier: "toCreatePost", sender: nil)
    }
    
    @objc func toComments(_ sender: AnyObject){
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        let indexPath: IndexPath? = tableView.indexPathForRow(at: buttonPosition)
        
        selectedPost = posts[(indexPath?.row)!]
        performSegue(withIdentifier: "toComments", sender: nil)
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
