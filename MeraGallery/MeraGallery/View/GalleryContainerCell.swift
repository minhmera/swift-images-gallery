//
//  GalleryContainerCell.swift
//  MeraGallery
//
//  Created by NhatMinh on 11/11/2022.
//

import UIKit
import Alamofire
import AlamofireImage

class GalleryContainerCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    let numberOfItemsInRow: CGFloat = 7
    let numberOfItemsInColoum: CGFloat = 10
    let minItemSpacing: Double = 2
    let kGalleryCellName: String = String(describing: GalleryCell.self)
    private var imageList: [GalleryModel] = [GalleryModel]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private var cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //collectionView.isHidden = true
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: kGalleryCellName, bundle: .main), forCellWithReuseIdentifier: kGalleryCellName)
        //collectionView.collectionViewLayout = TopAlignedCollectionViewFlowLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceHorizontal = true
        
    }
    
    private func loadImageData(imageUrl: String,completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            if let url = URL(string: imageUrl) {
                AF.request(url).responseImage { response in
                    if case .success(let image) = response.result {
                        completion(image)
                    }
                }
            }
        }
        
    }
    
    func setupData(imageList: [GalleryModel], needResetCache: Bool = false) {
        if needResetCache {
            cache.removeAllObjects()
        }
        self.imageList = imageList
    }
    
}

extension GalleryContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: kGalleryCellName, for: indexPath) as? GalleryCell else { fatalError("Unexpected indexPath") }
        
        
        let itemNumber = NSNumber(value: indexPath.item)
        if let cachedImage = self.cache.object(forKey: itemNumber) {
            print("Image From: a cached image for item: \(itemNumber)")
            cell.imageView.image = cachedImage
        } else {
            loadImageData(imageUrl: self.imageList[indexPath.row].imageUrl) { [weak self] (image) in
                print("Image From: API  \(indexPath.row)")
                guard let self = self, let image = image else { return }
                cell.setupData(galleryData: self.imageList[indexPath.row], imageData: image)
                self.cache.setObject(image, forKey: itemNumber)
            }
        }
        
        return cell
        
    }
    
}

extension GalleryContainerCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: Double = (UIScreen.main.bounds.width / numberOfItemsInRow) - minItemSpacing
        let height = (collectionView.bounds.height / numberOfItemsInColoum) - minItemSpacing
        return CGSize(width: width, height: height)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}
