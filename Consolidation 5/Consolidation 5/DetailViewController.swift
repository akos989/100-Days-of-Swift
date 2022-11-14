//
//  DetailViewController.swift
//  Consolidation 5
//
//  Created by Ákos Morvai on 2022. 04. 17..
//

import UIKit

// Todo: make like button work here as well
class DetailViewController: UIViewController {
    @IBOutlet var pictureImageView: UIImageView!
    
    var picture: Picture?
    
    var likeTappedDelegate: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let picture = picture {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: picture.liked ? "heart.fill" : "heart"), style: .plain, target: self, action: #selector(likeTapped))
            navigationItem.rightBarButtonItem?.tintColor = .red
            
            pictureImageView.image = UIImage(contentsOfFile: picture.imageURL)
        }
    }
    
    @objc func likeTapped(_ sender: UIButton) {
        guard let picture = picture else { return }
        
        picture.liked.toggle()
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: picture.liked ? "heart.fill" : "heart")
        if let likeTappedDelegate = likeTappedDelegate {
            likeTappedDelegate(picture.liked)
        }
    }
}
