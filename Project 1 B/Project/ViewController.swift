//
//  ViewController.swift
//  Project
//
//  Created by Ákos Morvai on 2022. 03. 07..
//

import UIKit

class ViewController: UICollectionViewController {

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else
            { fatalError("Unable to dequeue PictureCell.") }
        
        cell.name.text = pictures[indexPath.item]
        cell.picture.image = UIImage(named: pictures[indexPath.item])
        cell.picture.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.picture.layer.borderWidth = 2
        cell.picture.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedImagePosition = indexPath.row
            vc.totalImageNumber = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
