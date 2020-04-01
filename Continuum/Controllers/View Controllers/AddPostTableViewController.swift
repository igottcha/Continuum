//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Chris Gottfredson on 3/31/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var addCaptionTextField: UITextField!
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.selectImageButton.setTitle("Select Image", for: .normal)
        addCaptionTextField.text = nil
        photoImageView.image = nil
        
    }

    //MARK: - Actions
    
    @IBAction func selectImageButtonTapped(_ sender: Any) {
        photoImageView.image = #imageLiteral(resourceName: "spaceEmptyState")
        selectImageButton.setTitle("", for: .normal)
    }
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        createPost()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }

    //MARK: - Methods
    
    func createPost() {
        guard let image = photoImageView.image, let caption = addCaptionTextField.text else { return }
        PostController.shared.createPostWith(image: image, caption: caption) { (post) in
        }
        self.tabBarController?.selectedIndex = 0
    }
    
}
