//
//  MediaSelectorCollectionViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/2/21.
//

import UIKit
import Photos

class MediaSelectorCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  let cellId = "cellId"
  let headerId = "headerId"
  
  var images = [UIImage]()
  var selectedImage: UIImage?
  var assets = [PHAsset]()
  var header: MediaSelectorHeaderCollectionViewCell?
  
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    
    // Register cell classes
    collectionView?.register(MediaSelectorCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    
    collectionView?.register(MediaSelectorHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    
    setupNavigationButtons()
    
    fetchPhotos()
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: - HELPER METHODS
  
  private func assetsFetchOptions() -> PHFetchOptions {
    let fetchOptions = PHFetchOptions()
    fetchOptions.fetchLimit = 30
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    fetchOptions.sortDescriptors = [sortDescriptor]
    return fetchOptions
  }
  
  private func fetchPhotos() {
    print("Fetching photos")
    
    let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
    
    DispatchQueue.global(qos: .background).async {
      allPhotos.enumerateObjects { asset, count, stop in

        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: 200, height: 200)
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { [weak self] (image, info) in
          
          if let image = image {
            self?.images.append(image)
            self?.assets.append(asset)
            
            if self?.selectedImage == nil {
              self?.selectedImage = image
            }
          }
          
          if count == allPhotos.count - 1 {
            DispatchQueue.main.async {
              self?.collectionView.reloadData()
            }
          }
          
        }
      }
    }
    
    
  }
  
  private func setupNavigationButtons() {
    navigationController?.navigationBar.tintColor = .black
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
  }
  
  
  // MARK: - ACTION METHODS
  @objc private func handleCancel() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func handleNext() {
    let shareMediaController = ShareMediaViewController()
    shareMediaController.selectedImage = header?.imageView.image
    navigationController?.pushViewController(shareMediaController, animated: true)
  }
  
  // MARK: - UICOLLECTIONVIEW DATASOURCE
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MediaSelectorCollectionViewCell
    
    // Configure the cell
    cell.photoImageView.image = images[indexPath.item]
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MediaSelectorHeaderCollectionViewCell
    
    self.header = header
    
    header.imageView.image = selectedImage
    
    if let selectedImage = selectedImage {
      if let index = self.images.firstIndex(of: selectedImage) {
        let selectedAsset = self.assets[index]
        
        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: 600, height: 600)
        imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
          
          header.imageView.image = image
          
        }
      }
    }
    

    
    return header
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (view.frame.width - 3) / 4
    return CGSize(width: width, height: width)
  }
  
  // changes horizontal lize spacing
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  // changes vertical line spacing
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
 
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let width = view.frame.width
    return CGSize(width: width, height: width)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.selectedImage = images[indexPath.item]
    self.collectionView?.reloadData()
    
    let indexPath = IndexPath(item: 0, section: 0)
    collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
  }
  
}
