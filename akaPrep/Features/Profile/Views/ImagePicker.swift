//
//  ImagePicker.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/7/24.
//

import CoreData
import SwiftUI
import TOCropViewController

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    var context: NSManagedObjectContext

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false // Enable editing
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let originalImage = info[.originalImage] as? UIImage {
                // Present TOCropViewController for circular cropping
                let cropViewController = TOCropViewController(croppingStyle: .circular, image: originalImage)
                cropViewController.delegate = self
                picker.present(cropViewController, animated: true, completion: nil)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        // TOCropViewControllerDelegate methods
        func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
            parent.selectedImage = image
            
            let fetchRequest: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()

            do {
                let profileEntity = try parent.context.fetch(fetchRequest).first ?? ProfileEntity(context: parent.context)
                profileEntity.saveProfilePicture(image: image, context: parent.context)
            } catch {
                print("Failed to save profile picture: \(error)")
            }
            
            cropViewController.dismiss(animated: true) {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }

        func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
            cropViewController.dismiss(animated: true) {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
