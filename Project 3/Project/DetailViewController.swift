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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
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
    
    @objc func shareTapped() {
        guard let image = imageView.image else { return }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: image.size.width, height: image.size.height))
        
        let imageWithText = renderer.image { context in
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 35),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "From Storm Viewer"
            
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            attributedString.draw(with: CGRect(x: 0, y: 40, width: image.size.width, height: 30), options: .usesLineFragmentOrigin, context: nil)
        }
        
        guard let sharedImage = imageWithText.jpegData(compressionQuality: 1), let imageName = selectedImage else {
            print("Cannot convert image")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [sharedImage, imageName], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

        present(vc, animated: true)
    }
}
