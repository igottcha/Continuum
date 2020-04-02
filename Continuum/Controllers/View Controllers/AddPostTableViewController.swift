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
    
    @IBOutlet weak var addCaptionTextField: UITextField!
    
    //MARK: - Property
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCaptionTextField.autocapitalizationType = .sentences
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        addCaptionTextField.text = nil
        
    }

    //MARK: - Actions
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        createPost()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }

    //MARK: - Methods
    
    func createPost() {
        guard let image = selectedImage, let caption = addCaptionTextField.text else { return }
        PostController.shared.createPostWith(image: image, caption: caption) { (post) in
        }
        self.tabBarController?.selectedIndex = 0
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChildView" {
            guard let destinationVC = segue.destination as? PhotoSelectorViewController else { return }
            destinationVC.photoSelectorVCDelegate = self
        }
    }
}

extension AddPostTableViewController: PhotoSelectorViewControllerDelegate {
    func photoSelectorViewControllerSelected(image: UIImage) {
        selectedImage = image
    }
}
