//
//  DetailViewController.swift
//  Project
//
//  Created by Ákos Morvai on 2022. 03. 09..
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedImagePosition: Int?
    var totalImageNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imagePosition = selectedImagePosition,
            let totalNumber = totalImageNumber {
            title = "\(imagePosition + 1) of \(totalNumber)"
        } else {
            title = selectedImage
        }
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
