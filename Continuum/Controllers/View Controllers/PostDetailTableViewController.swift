//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Chris Gottfredson on 3/31/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    //MARK: - Properties
    
//    let refreshControl = UIRefreshControl()
    
    var post: Post? {
        didSet
        {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Actions
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        presentCommentAlertController()
        print("comment works")
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        guard let caption = post?.caption, let photo = post?.photo else { return }
        let shareActivity = UIActivityViewController(activityItems: [caption, photo], applicationActivities: nil)
        present(shareActivity, animated: true)
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
        print("follow works")
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return post?.comments.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailPostCell", for: indexPath)
        guard let post = post else { return cell}
        let comment = post.comments[indexPath.row]
        
        cell.textLabel?.text = comment.text
        cell.detailTextLabel?.text = comment.timestamp.formatDate()
        return cell
    }
    
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
    
    //MARK: - Methods
    
//    func setupViews() {
//        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to see new Comments")
//        self.refreshControl.addTarget(self, action: #selector(self.tableView.reloadData), for: .valueChanged)
//        self.refreshControl.addSubview(refreshControl)
//    }
    
    func updateViews() {
        guard let post = post else { return }
        DispatchQueue.main.async {
            self.photoImageView.image = post.photo
//            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func presentCommentAlertController() {
        
        let alert = UIAlertController(title: "Add a Comment", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.delegate = self
            textField.placeholder = "What do you want to say?"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
        }
        
        let cancelCommentButton = UIAlertAction(title: "Cancel", style: .cancel)
        let oKCommentButton = UIAlertAction(title: "OK", style: .default) { (_) in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            PostController.shared.addComment(text: text, post: self.post) { (result) in
                switch result {
                case .success(_):
                    self.updateViews()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        alert.addAction(cancelCommentButton)
        alert.addAction(oKCommentButton)
        
        self.present(alert, animated: true)
    }
    
}

//MARK: - TextField Delegate

extension PostDetailTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
