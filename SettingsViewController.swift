//
//  SettingsViewController.swift
//  PokedexProject
//
//  Created by dirtbag on 12/13/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var gEmail = "x@y.com"
    var defaultImage = UIImage(named: K.Image.defaultUserImage)
    var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        // read user's image and load it
        let user = CoreDataFetchOps.shared.getUserby(email: gEmail).first
        if let data = user?.imageData {
            let uiImage = UIImage(data: data)
            imageView.image = uiImage
        }

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    @IBAction func btnActionPickImage(_ sender: UIButton) {

        self.imagePicker.present(from: sender)
    }

    @IBAction func btnReset(_ sender: Any) {

        imageView.image = defaultImage
        let user = CoreDataFetchOps.shared.getUserby(email: gEmail).first
        user?.imageData = nil
        CoreDataManager.shared.saveContext(context: CoreDataManager.shared.mainContext)
    }
}

extension SettingsViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.imageView.image = image

        // save user's image for next login
        let user = CoreDataFetchOps.shared.getUserby(email: gEmail).first
        let pngData = image?.pngData()
        if let data = pngData {
            user?.imageData = data
            CoreDataManager.shared.saveContext(context: CoreDataManager.shared.mainContext)
        }
    }
}
