//
//  GalleryCell.swift
//  MeraGallery
//
//  Created by NhatMinh on 10/11/2022.
//

import UIKit

class GalleryCell: UICollectionViewCell {

    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.handleLoading(isLoading: true)
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.imageView.image = nil
//        self.handleLoading(isLoading: true)
//        
//    }
    
    private func setupUI() {
        imageView.layer.cornerRadius = 7
    }
    
    private func handleLoading(isLoading: Bool) {
        if isLoading {
            loadingView.isHidden = false
            loadingIndicator.startAnimating()
        } else {
            loadingView.isHidden = true
            loadingIndicator.stopAnimating()
        }
        
    }
    
    func setupData(galleryData: GalleryModel, imageData: UIImage) {
        imageView.image = imageData
        handleLoading(isLoading: false)
    }

}
