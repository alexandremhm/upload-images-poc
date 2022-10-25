//
//  ViewController.swift
//  UploadPhotosPOC
//
//  Created by Matheus Henrique Mendes Alexandre on 24/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    weak var imgProfile: UIImage!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var viewModel = UploadViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        getImages()
    }
    
    func getImages() {
        viewModel.fetchBreweryImages(breweryId: "ofallon-brewery-maryland-heights") { result in
            switch result {
            case .success(let images):
                DispatchQueue.main.async {
                    let url = images[2].url
                    guard let urlImage = URL(string: url) else { return }
                    self.image.load(urlImage, placeholder: UIImage(named: "imageplace"))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        
        let alert = UIAlertController(title: "Adicionar Foto", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Câmera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Galeria", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancelar", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = sender as! CGRect
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        present(alert, animated: true)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Atenção", message: "Câmera não disponível!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func generateBoundary() -> String {
        let boundary = UUID().uuidString
        return boundary
    }
        
    
    func generateImageData(fileName: String, boundary: String, image: UIImage, paramName: String) -> Data {
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return data
    }
}

extension ViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            let boundary = self.generateBoundary()
            let data = self.generateImageData(fileName: "ofallon-brewery-maryland-heights2", boundary: boundary, image: editedImage, paramName: "file")
            self.viewModel.uploadImage(data: data, boundary: boundary, breweryId: "ofallon-brewery-maryland-heights")
            }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
}

