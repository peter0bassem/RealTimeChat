//
//  ImagePickerManager.swift
//  Login Location
//
//  Created by Peter Bassem on 2/13/19.
//  Copyright © 2019 Peter Bassem. All rights reserved.
//

import Foundation
import UIKit


class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController()
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage, URL?) -> ())?
    
    override init(){
        super.init()
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage, URL?) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController
        
        let cameraAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "camera", comment: ""), style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "gallary", comment: ""), style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: ""), style: UIAlertAction.Style.cancel){
            UIAlertAction in
        }
        // Add the actions
        picker.delegate = self
        picker.allowsEditing = true
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            
            let alertWarning = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "warning", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "noCamera", comment: ""), preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "ok", comment: ""), style: UIAlertAction.Style.default, handler: nil)
            alertWarning.addAction(okButton)
            viewController?.present(alertWarning, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let ref = info[UIImagePickerController.InfoKey.imageURL] as? URL
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            pickImageCallback?(editedImage, ref)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickImageCallback?(originalImage, ref)
        }
        picker.dismiss(animated: true, completion: nil)
    }
//    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
//    }
    
}
