//
//  ImageCollectionViewCell.swift
//  Privacy Project
//
//  Created by Timothy/Ammar/Chandra on 12/2/19.
//  Copyright © 2019 PETS. All rights reserved.
//

import UIKit

//Define the image collection view cell
class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
