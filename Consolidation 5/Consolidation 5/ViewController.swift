//
//  ViewController.swift
//  Consolidation 5
//
//  Created by Ákos Morvai on 2022. 04. 17..
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhotoTapped))
        
        if let savedPicturesData = UserDefaults.standard.object(forKey: "pictures") as? Data {
            do {
                pictures = try JSONDecoder().decode([Picture].self, from: savedPicturesData)
            } catch {
                print("Failed to load pictures.")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) as? PictureTableViewCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        cell.initializeCell(with: pictures[indexPath.row])
        cell.likeTappedDelegate = {
            [weak self] liked in
            self?.pictures[indexPath.row].liked = liked
            self?.savePicturesToUserDefaults()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.picture = pictures[indexPath.row]
            vc.likeTappedDelegate = {
                [weak self] liked in
                self?.pictures[indexPath.row].liked = liked
                self?.savePicturesToUserDefaults()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "New picture name", message: "Give the name of the new picture", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Create", style: .default) {
            [weak self, weak ac] _ in
            if let pictureName = ac?.textFields?[0].text,
               pictureName != "" {
                self?.createPictureWith(image: image, name: pictureName)
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func addPhotoTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let ac = UIAlertController(title: "Source", message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Photo Library", style: .default) {
                [weak self] _ in
                
                self?.addPhoto(with: .photoLibrary)
            })
            ac.addAction(UIAlertAction(title: "Camera", style: .default) {
                [weak self] _ in
                self?.addPhoto(with: .camera)
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(ac, animated: true)
        } else {
            addPhoto(with: .photoLibrary)
        }
    }
    
    private func createPictureWith(image: UIImage, name pictureName: String) {
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 1) {
            try? jpegData.write(to: imagePath)
        }
        let path = imagePath.path
        
        pictures.append(Picture(name: pictureName, imageURL: path, liked: false))
        let indexPath = IndexPath(row: pictures.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        savePicturesToUserDefaults()
    }
    
    private func addPhoto(with sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func savePicturesToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(pictures) {
            UserDefaults.standard.set(encodedData, forKey: "pictures")
        }
    }
}
