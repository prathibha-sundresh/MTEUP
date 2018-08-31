//
//  WSGalleryViewController.swift
//  yB2CApp
//
//  Created by Ramakrishna on 12/1/17.
//

import UIKit
import Photos
import PhotosUI

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

class WSGalleryViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var usePhotoButton: UIButton!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    var callBack: ((_ menuCardArray:[[String:Any]]) -> Void)?
    
    enum PresentationStyle {
        case Modal
        case Show
    }
    
    enum GalleryScreenOpenFor {
        case OnBoarding
        case Myprofile
    }
    
    var presentationStyle:PresentationStyle = .Show
    var screenOpenFor:GalleryScreenOpenFor = .OnBoarding
    
    var fetchResult: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection!
    var selectedIndexPaths = [IndexPath]()
    
    var selectedIndex: Int = 0
    
    fileprivate lazy var imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!
    fileprivate var previousPreheatRect = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
       backButton.setTitle(WSUtility.getlocalizedString(key: "Back", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        selectedIndexPaths = [IndexPath(row: 0, section: 0)]
        usePhotoButton.setTitle(WSUtility.getlocalizedString(key: "Use photo", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    }
    
    deinit {
        if WSUtility.checkPhotoLibraryAccessPermission() {
            PHPhotoLibrary.shared().unregisterChangeObserver(self as PHPhotoLibraryChangeObserver)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if WSUtility.checkPhotoLibraryAccessPermission() {
            checkPhotoLibraryAccessPermission()
            updateItemSize()
        } else {
            alertWhenNoAccess()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if WSUtility.checkPhotoLibraryAccessPermission() {
            updateCachedAssets()
//            self.galleryCollectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(sender: Any){
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func usePhotoButton_Click(sender: UIButton){
        
    }
    
    func checkPhotoLibraryAccessPermission()  {
        usePhotoButton.isEnabled = true
        usePhotoButton.alpha = 1
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            
            self.fetchResult = nil
            photoFrameWorkSetupAfterAccessPermission()
        }
            
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            alertWhenNoAccess()
        }
            
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    
                    self.fetchResult = nil
                    self.photoFrameWorkSetupAfterAccessPermission()
                    
                }
                    
                else {
                    
                }
                DispatchQueue.main.async {
                    self.updateItemSize()
                    self.galleryCollectionView.reloadData()
                }
            })
            
        }
            
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
            // UFSUtility.showAlertWith(message: photoAccessDeniedMessage, title: "", forController: self)
        }
    }
    
    func alertWhenNoAccess() {
        let errorMessage = WSUtility.getlocalizedString(key: "Please give the permission to use Camera/Gallery for this app feature.", lang: WSUtility.getLanguage())
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: .alert)
        usePhotoButton.isEnabled = false
        usePhotoButton.alpha = 0.25
        alert.addAction(UIAlertAction(title: WSUtility.getlocalizedString(key: "Open Settings", lang: WSUtility.getLanguage()), style: .default, handler: { (_) in
            DispatchQueue.main.async {
                if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(settingsURL)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: WSUtility.getlocalizedString(key: "NotNow", lang: WSUtility.getLanguage()), style: .cancel, handler: { (_)in
            self.navigationController?.popViewController(animated: true)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func photoFrameWorkSetupAfterAccessPermission()  {
        
        resetCachedAssets()
        PHPhotoLibrary.shared().register(self as PHPhotoLibraryChangeObserver)
        
        // If we get here without a segue, it's because we're visible at app launch,
        // so match the behavior of segue from the default "All Photos" view.
        if fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchResult = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
        }
        
    }

    
    func retriveImageFromPHAssetManagerAndUpdateToAdminServer()  {
        
        UFSProgressView.showWaitingDialog("")
        
        var imageData = [Data]()
        
        for indexPath in selectedIndexPaths{
            let asset = fetchResult.object(at: indexPath.item)
            
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            imageManager.requestImageData(for: asset, options: options) { (result, string, orientation, info) -> Void in
                if result != nil {
                    imageData.append(result!)
                } else {
                    
                }
            }
            
        }
        
        guard imageData.count > 0 else {
            UFSProgressView.stopWaitingDialog()
            return
        }
        
        if screenOpenFor == .Myprofile {
            self.uploadProfileImage(image: imageData)
        }else{
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoUploadVC"{
            let photoUploadVC = segue.destination as! WSPhotoUploadViewController
            let cell:GridViewCell = galleryCollectionView.cellForItem(at: IndexPath(row: selectedIndex, section: 0)) as! GridViewCell
            photoUploadVC.asset = fetchResult.object(at: selectedIndex)
            print(cell.thumbnailImage)
            photoUploadVC.thumbnailImage = cell.thumbnailImage
            //photoUploadVC.uploadImage.image = cell.thumbnailImage
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        if presentationStyle == .Modal {
            self.dismiss(animated: false, completion: nil)
            performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
            return
        }
        
//        if navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 2] is UFSCameraViewController{
//            
//            if (navigationController?.viewControllers.count)! > 2{
//                let viewController = navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 3]
//                self.navigationController?.popToViewController(viewController!, animated: true)
//                return
//            }
//        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        retriveImageFromPHAssetManagerAndUpdateToAdminServer()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func goBackToOneButtonTapped() {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    
    func uploadProfileImage(image:[Data]) {
        
//        UFSImageUploadFileManager.uploadImages(imageData: image, apiMethodName: APIMethodName().UPLOAD_PROFILE_IMAGE, imageName: "profile_image", successResponse: { (responseObject) in
//            //self.saveMenuCardInDocumentsDirectory(imageData: image)
//
//            let profileImagePath = UFSUtility.saveImageDocumentDirectory(imageData: image[0], ImageName: "MyProfile")
//            UserDefaults.standard.set(profileImagePath, forKey: USER_PROFILE_IMAGE_URL)
//
//            UFSProgressView.stopWaitingDialog()
//            //self.backButtonTapped(UIButton())
//            self.performSegue(withIdentifier: "unWindToMyAccount", sender: self)
//
//        }) { (errorMessage) in
//            UFSProgressView.stopWaitingDialog()
//        }
        
    }
    
    func toggleCheckBox(cell:GridViewCell, forIndexPath indexPath:IndexPath)  {
        if selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.remove(at: selectedIndexPaths.index(of: indexPath)!)
            cell.selectionImageView.image = UIImage(named: "gallery_unsel")
        }else{
            if selectedIndexPaths.count < 10 {
                selectedIndexPaths.append(indexPath)
                cell.selectionImageView.image = UIImage(named: "gallery_sel")
            }else{
                
            }
            
        }
        
    }
    
    func toggleCheckBoxForSingleSelection(cell:GridViewCell, forIndexPath indexPath:IndexPath)  {
        
        cell.shadeView.isHidden = true
        if selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.remove(at: selectedIndexPaths.index(of: indexPath)!)
            cell.selectionImageView.image = UIImage(named: "gallery_unsel")
        }else{
            if selectedIndexPaths.count > 0 {
                let previousIndexPath = selectedIndexPaths[0]
                let previousCell:GridViewCell = galleryCollectionView.cellForItem(at: previousIndexPath) as! GridViewCell
                previousCell.selectionImageView.image = UIImage(named: "gallery_unsel")
                selectedIndexPaths.removeAll()
                selectedIndexPaths.append(indexPath)
            }else{
                
                selectedIndexPaths.append(indexPath)
            }
            cell.shadeView.isHidden = false
            cell.selectionImageView.image = UIImage(named: "gallery_sel")
            
        }
        
    }
    
    private func updateItemSize() {
        
        let viewWidth = view.bounds.size.width
        
        let desiredItemWidth: CGFloat = 100
        let columns: CGFloat = max(floor(viewWidth / desiredItemWidth), 3)
        let padding: CGFloat = 5
        let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        if let layout = galleryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = itemSize
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            
        }
        
        // Determine the size of the thumbnails to request from the PHCachingImageManager
        let scale = UIScreen.main.scale
        thumbnailSize = CGSize(width: itemSize.width * scale, height: itemSize.height * scale)
    }
    
    
    // MARK: UIScrollView
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //updateCachedAssets()
    }
    
    // MARK: Asset Caching
    
    fileprivate func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    
    fileprivate func updateCachedAssets() {
        
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else { return }
        
        // The preheat window is twice the height of the visible rect.
        let visibleRect = CGRect(origin: galleryCollectionView!.contentOffset, size: galleryCollectionView!.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        
        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }
        
        // Compute the assets to start caching and to stop caching.
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets = addedRects
            .flatMap { rect in galleryCollectionView!.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        let removedAssets = removedRects
            .flatMap { rect in galleryCollectionView!.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        
        // Update the assets the PHCachingImageManager is caching.
        imageManager.startCachingImages(for: addedAssets,
                                        targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        imageManager.stopCachingImages(for: removedAssets,
                                       targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        
        // Store the preheat rect to compare against in the future.
        previousPreheatRect = preheatRect
    }
    
    fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
    
}

extension WSGalleryViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    /*
     public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
     return CGSize(width: self.view.frame.size.width, height: 0)
     
     }
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if fetchResult == nil{
            return 0
        }
        
        return fetchResult.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let asset = fetchResult.object(at: indexPath.item)
        // print("creation date : \(String(describing: asset.creationDate))")
        // Dequeue a GridViewCell.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridViewCell.self),for: indexPath) as? GridViewCell
            else { fatalError("unexpected cell in collection view") }
        
        
        // Request an image for the asset from the PHCachingImageManager.
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            // The cell may have been recycled by the time this handler gets called;
            // set the cell's thumbnail image only if it's still showing the same asset.
            if cell.representedAssetIdentifier == asset.localIdentifier && image != nil {
                cell.thumbnailImage = image
            }
        })
        
        if selectedIndex == indexPath.item {
            cell.selectionImageView.image = UIImage(named: "gallery_sel")
            cell.shadeView.isHidden = false
        }else{
            cell.selectionImageView.image = UIImage(named: "gallery_unsel")
            cell.shadeView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.item
        galleryCollectionView.reloadData()
//        let cell:GridViewCell = collectionView.cellForItem(at: indexPath) as! GridViewCell
//
//        self.toggleCheckBoxForSingleSelection(cell: cell, forIndexPath: indexPath)
//        if screenOpenFor == .Myprofile {
//            self.toggleCheckBoxForSingleSelection(cell: cell, forIndexPath: indexPath)
//        }else{
//            if selectedIndexPaths.count <= 10 {
//                toggleCheckBox(cell: cell, forIndexPath: indexPath)
//            }
//        }
        
//        if let layout = galleryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.footerReferenceSize = selectedIndexPaths.count > 0 ? CGSize(width: self.view.frame.size.width, height: 49) : CGSize(width: self.view.frame.size.width, height: 0)
//
//        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width / 3 - 3, height: UIScreen.main.bounds.width / 3 - 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}

// MARK: PHPhotoLibraryChangeObserver
extension WSGalleryViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: fetchResult)
            else { return }
        
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            // Hang on to the new fetch result.
            fetchResult = changes.fetchResultAfterChanges
            if changes.hasIncrementalChanges {
                // If we have incremental diffs, animate them in the collection view.
                guard let collectionView = self.galleryCollectionView else { fatalError() }
                collectionView.performBatchUpdates({
                    // For indexes to make sense, updates must be in this order:
                    // delete, insert, reload, move
                    if let removed = changes.removedIndexes, !removed.isEmpty {
                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let inserted = changes.insertedIndexes, !inserted.isEmpty {
                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let changed = changes.changedIndexes, !changed.isEmpty {
                        collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                to: IndexPath(item: toIndex, section: 0))
                    }
                })
            } else {
                // Reload the collection view if incremental diffs are not available.
                galleryCollectionView.reloadData()
            }
            resetCachedAssets()
        }
    }
}

