//
//  ImagePicker.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 27/10/20.
//  Copyright © 2020 Chintan Maisuriya. All rights reserved.
//

import UIKit

public protocol ImagePickerDelegate: AnyObject
{
    func didSelect(image: UIImage?)
}


class ImagePicker: NSObject
{
    //MARK: -
    private let pickerController            : UIImagePickerController
    private weak var presentationController : UIViewController?
    private weak var delegate               : ImagePickerDelegate?

    //MARK: -

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate)
    {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate               = delegate

        self.pickerController.delegate      = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes    = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction?
    {
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return nil }

        return UIAlertAction(title: title, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.pickerController.sourceType                = type
            self.pickerController.modalPresentationStyle    = .fullScreen
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView)
    {
        let alertController = UIAlertController(title: Application.displayName, message: "Please choose a picture source", preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo")
        {
            alertController.addAction(action)
        }
        
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll")
        {
            alertController.addAction(action)
        }
        
        if let action = self.action(for: .photoLibrary, title: "Photo library")
        {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad
        {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        DispatchQueue.main.async {
            self.presentationController?.present(alertController, animated: true)
        }
        
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?)
    {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image)
    }
}


//MARK:-

extension ImagePicker: UIImagePickerControllerDelegate
{
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        
        self.pickerController(picker, didSelect: image)
    }
}

//MARK: -

extension ImagePicker: UINavigationControllerDelegate
{
}

