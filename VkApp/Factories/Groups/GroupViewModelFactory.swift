//
//  GroupViewModelFactory.swift
//  VkApp
//
//  Created by Карим Руабхи on 22.05.2022.
//

import UIKit
import RealmSwift

class GroupViewModelFactory {
    func getModels(groups: Results<RealmGroup>?, photoService: PhotoService) -> [GroupViewModel] {
        guard let groups = groups else { return [] }
        var viewModelsArray: [GroupViewModel] = []
        for group in groups {
            guard
                let image = photoService.photo(byUrl: group.photo)
            else { continue }
            viewModelsArray.append(GroupViewModel(image: image, name: group.name))
        }
        return viewModelsArray
    }
    
    func getModels(array: [GroupData], photoService: PhotoService) -> [GroupViewModel] {
        var viewModelsArray: [GroupViewModel] = []
        DispatchQueue.main.async {
            array.forEach { i in
                let imageView = UIImageView()
                imageView.downloaded(from: i.photo)
                
                guard
                    let image = imageView.image
                else { return }
                viewModelsArray.append(GroupViewModel(
                    image: image,
                    name: i.name
                ))
            }
        }
        
        return viewModelsArray
    }
}
