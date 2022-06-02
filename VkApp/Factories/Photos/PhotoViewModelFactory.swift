//
//  PhotoViewModelFactory.swift
//  VkApp
//
//  Created by Карим Руабхи on 22.05.2022.
//

import UIKit
import RealmSwift

class PhotoViewModelFactory {
    var photoService: PhotoService
    var viewModels: [PhotoViewModel] = []
    weak var source: UpdateViewModels?
    var photos: Results<RealmPhotoCell>?
    var id: Int
    var photosBigSize: [String]
    private var networkService = RequestProxy(request: Request<Albums>())
    
    init(collectionView: UICollectionView, source: UpdateViewModels, id: Int, photosBigSize: [String], photos: Results<RealmPhotoCell>?) {
        self.source = source
        self.photoService = PhotoService(container: collectionView)
        self.id = id
        self.photosBigSize = photosBigSize
        self.photos = photos
    }
    
    
    func loadPhotos() {
        networkService.fetch(type: .photos, id: id) { [weak self] result in
            switch result {
            case .success(let photos):
                let items = photos.map { i -> RealmPhotoCell in
                    self?.photosBigSize.append(i.sizes.last?.url ?? "")
                    let value = i.sizes.first { i in
                        i.type == "p"
                    }
                    let elem = RealmPhotoCell(photo: Photo(
                        width: value?.width ?? 0,
                        height: value?.height ?? 0,
                        url: value?.url ?? "",
                        type: value?.type ?? ""))
                    return elem
                }
                DispatchQueue.main.async {
                    do {
                        try RealmService.save(items: items)
                        self?.photos = try RealmService.load(typeOf: RealmPhotoCell.self)
                    } catch {
                        print(error)
                    }
                    
                    self?.photos?.forEach { i in
                        guard
                            let image = self?.photoService.photo(byUrl: i.url)
                        else { return }
                        let viewModel = PhotoViewModel(image: image)
                        self?.viewModels.append(viewModel)
                    }
                    
                    self?.source?.updateViewModels()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
