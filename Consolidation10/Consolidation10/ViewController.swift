//
//  ViewController.swift
//  Consolidation10
//
//  Created by Ákos Morvai on 2022. 07. 20..
//

import CoreGraphics
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    
    var renderer: UIGraphicsImageRenderer?
    
    var originalImage: UIImage?
    var upperText = ""
    var bottomText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importNewPhoto))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(displayActions)),
            UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPhoto))
        ]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        originalImage = image
        drawImageOnCanvas()
    }
    
    func drawImageOnCanvas() {
        guard let image = originalImage else { return }
        renderer = UIGraphicsImageRenderer(size: image.size)
        
        let canvasImage = renderer?.image { context in
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
                        
            let topAttributedString = NSAttributedString(string: upperText, attributes: attributes)
            topAttributedString.draw(with: CGRect(x: 0, y: 30, width: image.size.width, height: 40), options: .usesLineFragmentOrigin, context: nil)
            
            let bottomAttributedString = NSAttributedString(string: bottomText, attributes: attributes)
            bottomAttributedString.draw(with: CGRect(x: 0, y: image.size.height - 70, width: image.size.width, height: 40), options: .usesLineFragmentOrigin, context: nil)
        }
        
        imageView.image = canvasImage
    }

    @objc func importNewPhoto() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func editPhoto() {
        let ac = UIAlertController(title: "Edit image", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Top text", style: .default, handler: editText))
        ac.addAction(UIAlertAction(title: "Bottom text", style: .default, handler: editText))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[0]
        present(ac, animated: true)
    }
    
    @objc func displayActions() {
        guard let image = imageView.image else { return }
        
        guard let sharedImage = image.jpegData(compressionQuality: 1) else { print("cannot convert image"); return }
        
        let vc = UIActivityViewController(activityItems: [sharedImage, "Edited Meme"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[1]
        
        present(vc, animated: true)
    }
    
    func editText(_ alertAction: UIAlertAction) {
        dismiss(animated: true)
        
        let ac = UIAlertController(title: alertAction.title, message: "Write the text of the meme", preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].text = alertAction.title == "Top text" ? upperText : bottomText
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            if let text = ac?.textFields?[0].text {
                if alertAction.title == "Top text" {
                    self?.upperText = text
                } else {
                    self?.bottomText = text
                }
                self?.drawImageOnCanvas()
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}
