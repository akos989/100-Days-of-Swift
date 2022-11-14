//
//  PictureTableViewCell.swift
//  Consolidation 5
//
//  Created by Ákos Morvai on 2022. 04. 17..
//

import UIKit

class PictureTableViewCell: UITableViewCell {
    @IBOutlet var pictureImageView: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var likeView: UIView!
    
    var likeTappedDelegate: ((Bool) -> Void)?
    
    var picture: Picture?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCell(with newPicture: Picture) {
        self.picture = newPicture
        
        pictureImageView.image = UIImage(contentsOfFile: picture!.imageURL)
        pictureImageView.layer.borderWidth = 1
        pictureImageView.layer.cornerRadius = 3
        
        label.text = picture!.name
        
        let likeButton = UIButton(type: .system)
        likeButton.setImage(UIImage(systemName: picture!.liked ? "heart.fill" : "heart"), for: .normal)
        likeButton.tintColor = .red
        
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.centerXAnchor.constraint(equalTo: likeView.centerXAnchor),
            likeButton.centerYAnchor.constraint(equalTo: likeView.centerYAnchor),
            likeButton.widthAnchor.constraint(equalTo: likeView.widthAnchor),
            likeButton.heightAnchor.constraint(equalTo: likeView.heightAnchor)
        ])
    }
    
    @objc func likeTapped(_ sender: UIButton) {
        guard let picture = picture else { return }
        
        picture.liked.toggle()
        sender.setImage(UIImage(systemName: picture.liked ? "heart.fill" : "heart"), for: .normal)
        if let likeTappedDelegate = likeTappedDelegate {
            likeTappedDelegate(picture.liked)
        }
    }
}
