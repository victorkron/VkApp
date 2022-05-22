//
//  FriendViewModelFactory.swift
//  VkApp
//
//  Created by Карим Руабхи on 22.05.2022.
//
import UIKit
import RealmSwift

class FriendViewModelFactory {

    var photoService: PhotoService
    var viewModels: [FriendsViewModel] = []
    var personsDictionary = [String: [String]]()
    var personSectionTitles = [String]()
    var source: UpdateViewModels
    
    init(tableView: UITableView, source: UpdateViewModels) {
        self.source = source
        self.photoService = PhotoService(container: tableView)
    }
    
    var friends: Results<RealmFriend>? = try? RealmService.load(typeOf: RealmFriend.self) {
        didSet {
            guard
                let friends = friends
            else { return }
            
            for friend in friends {
                guard
                    let element = getViewModel(photoService: photoService, friend: friend)
                else { return }
                viewModels.append(element)
            }
            
            for friend in friends where friend.firstName != "DELETED" {
                let personKey = String(friend.lastName.prefix(1))
                let personsName = "\(friend.lastName) \(friend.firstName)"
                if var personsValue = personsDictionary[personKey] {
                    if personsValue.contains(personsName) {

                    } else {
                        personsValue.append(personsName)
                        personsDictionary[personKey] = personsValue
                    }
                } else {
                    personsDictionary[personKey] = [personsName]
                }
            }
            personSectionTitles = [String](personsDictionary.keys)
            personSectionTitles = personSectionTitles.sorted(by: { $0 < $1 })
            for eachFriendsFirstChar in personsDictionary {
                personsDictionary[eachFriendsFirstChar.key] = eachFriendsFirstChar.value.sorted(by: { $0 < $1 })
            }
            source.updateViewModels()
        }
    }
    
    func getViewModel(
        photoService: PhotoService,
        friend: RealmFriend
    ) -> FriendsViewModel? {
        guard
            let image = photoService.photo(byUrl: friend.photo)
        else { return nil }
        let viewModel = FriendsViewModel(image: image, name: "\(friend.lastName) \(friend.firstName)")
        return viewModel
    }
}
