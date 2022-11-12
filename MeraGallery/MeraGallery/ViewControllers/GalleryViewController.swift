//
//  GalleryViewController.swift
//  MeraGallery
//
//  Created by NhatMinh on 10/11/2022.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class GalleryViewController: UIViewController {
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func btnAddOneAction(_ sender: Any) {
        addOneImage()
    }
    
    
    @IBAction func btnReloadAction(_ sender: Any) {
        reLoadImage()
    }

    private lazy var paginationManager: HorizontalPaginationManager = {
        let manager = HorizontalPaginationManager(scrollView: self.collectionView)
        manager.delegate = self
        return manager
    }()
    
    private var isDragging: Bool {
        return self.collectionView.isDragging
    }
    
    private var imageList: [GalleryModel] = [GalleryModel]()
    private var collectionImage: [[GalleryModel]] = [[GalleryModel]]() // => [page: images]
    var isNeedToResetCache: Bool = false
    
    let kGalleryContainerName: String = String(describing: GalleryContainerCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPagination()
        // Hard code load 4 page for the first time
        self.loadCollection(numberOfPage: 2)
        
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: kGalleryContainerName, bundle: .main), forCellWithReuseIdentifier: kGalleryContainerName)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceHorizontal = true
        
    }
    
    private func loadCollection(numberOfPage: Int,isAddOne: Bool = false,isReset: Bool = false) {
        if isReset {
            collectionImage.removeAll()
        }
        for _ in 0..<numberOfPage {
            var numberOfImagePerPage: Int = Int.random(in: 65..<70)
            if isAddOne {
                numberOfImagePerPage = 1
            }
            loadMultipleImage(numberOfImages: numberOfImagePerPage)
        }
    }
   
    
    private func loadMultipleImage(numberOfImages: Int) {
        var imagesPerPage: [GalleryModel] = [GalleryModel]()
        for _ in 0..<numberOfImages {
            // will change the url in real case
            let hardUrl: String = "http://loremflickr.com/200/200"
            imagesPerPage.append(GalleryModel(imageUrl: hardUrl))
        }
        collectionImage.append(imagesPerPage)
        collectionView.reloadData()
    }
    
    
    private func addOneImage() {
        isNeedToResetCache = false
        if collectionImage.count < 0 {
            return
        }
        if collectionImage.last!.count < 70 {
            collectionImage[collectionImage.count - 1].append(GalleryModel(imageUrl: "http://loremflickr.com/200/200"))
            collectionView.reloadData()
        } else {
            loadCollection(numberOfPage: 1,isAddOne: true)
        }
        collectionView.scrollToItem(at: IndexPath(row: collectionImage.count - 1, section: 0), at: .left, animated: true)
    }
    
    private func reLoadImage() {
        isNeedToResetCache = true
        collectionImage.removeAll()
        loadCollection(numberOfPage: 2)
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
    }
   
}


extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: kGalleryContainerName, for: indexPath) as? GalleryContainerCell else { fatalError("Unexpected indexPath") }
        cell.setupData(imageList: collectionImage[indexPath.row],needResetCache: self.isNeedToResetCache)
        return cell
        
    }
 
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        return CGSize(width: width,
                      height: height)
    }


    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

}


extension GalleryViewController: HorizontalPaginationManagerDelegate {
    private func setupPagination() {
        self.paginationManager.refreshViewColor = .clear
        self.paginationManager.loaderColor = .white
    }
    
    func refreshAll(completion: @escaping (Bool) -> Void) {
        isNeedToResetCache = true
        AppUtils.delay(2.0) {
            self.loadCollection(numberOfPage: 4,isReset: true)
            completion(true)
        }
        
    }
    
    func loadMore(completion: @escaping (Bool) -> Void) {
        isNeedToResetCache = false
        AppUtils.delay(2.0) {
            // Hard code load 3 page each time load more
            self.loadCollection(numberOfPage: 3)
            completion(true)
        }
        
    }
    
    
}
