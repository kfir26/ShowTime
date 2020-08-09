//
//  NewsFeedTableViewController.swift
//  ShowTime
//
//  Created by כפיר פנירי on 23/06/2020.
//  Copyright © 2020 Kfir & ShowTime. All rights reserved.
//

import UIKit
import Firebase

class NewsFeedTableViewController: UITableViewController {

    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        //downloadPosts
        // 1. create a referance to the posts on the database
        Database.database().reference().child("FeedPosts").observe(.childAdded){
            (snapshot) in
            // A.  get called for each of the exsiting child
            // B. get called whenever a new child is added to the parent key:
            // photoPosts
            print("HEY IM HERE ************:\(snapshot.value)")
            // 2. parse each of the post
            DispatchQueue.main.async {
                // 3. update the tableView
                let newPost = Post(snapshot: snapshot)
                self.posts.insert(newPost, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .top)
                
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell

        
        //original
        cell.post = self.posts[indexPath.row]
        


        return cell
    }
    ////////////////////////////////////////////////////////

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
