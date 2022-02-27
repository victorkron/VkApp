//
//  FriendsTableVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 17.12.2021.
//

import UIKit
import RealmSwift

final class FriendsTableVC: UITableViewController {
    
    var personsDictionary = [String: [String]]()
    var personSectionTitles = [String]()
    
    var friends: Results<RealmFriend>? = try? RealmService.load(typeOf: RealmFriend.self) {
        didSet {
            guard
                let friends = friends
            else { return }

            for friend in friends where friend.firstName != "DELETED" { // warning: hard unwrap
                let personKey = String(friend.lastName.prefix(1))
                if var personsValue = personsDictionary[personKey] {
                    if personsValue.contains(friend.lastName) {

                    } else {
                        personsValue.append(friend.lastName)
                        personsDictionary[personKey] = personsValue
                    }
                } else {
                    personsDictionary[personKey] = [friend.lastName]
                }
            }
            personSectionTitles = [String](personsDictionary.keys)
            personSectionTitles = personSectionTitles.sorted(by: { $0 < $1 })
            for eachFriendsFirstChar in personsDictionary {
                personsDictionary[eachFriendsFirstChar.key] = eachFriendsFirstChar.value.sorted(by: { $0 < $1 })
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
//    var friends = [User]() {
//        didSet {
//            for friend in friends where friend.firstName != "DELETED" {
//                let personKey = String(friend.lastName.prefix(1))
//                if var personsValue = personsDictionary[personKey] {
//                    if personsValue.contains(friend.lastName) {
//
//                    } else {
//                        personsValue.append(friend.lastName)
//                        personsDictionary[personKey] = personsValue
//                    }
//                } else {
//                    personsDictionary[personKey] = [friend.lastName]
//                }
//            }
//            personSectionTitles = [String](personsDictionary.keys)
//            personSectionTitles = personSectionTitles.sorted(by: { $0 < $1 })
//            for eachFriendsFirstChar in personsDictionary {
//                personsDictionary[eachFriendsFirstChar.key] = eachFriendsFirstChar.value.sorted(by: { $0 < $1 })
//            }
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }

    @IBAction func celarPhoto(segue: UIStoryboardSegue) {
        guard
            let sender = segue.source as? PhotosCollectionVC
        else { return }
        DispatchQueue.main.async {
            do {
                try RealmService.delete(object: sender.photos!)
            } catch {
                print(error)
            }
        }
    }
    // MARK: - Lifecycle
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(
                nibName: "FriendCell",
                bundle: nil),
            forCellReuseIdentifier: "friendCell")
        
        
        let request = Request()
        request.getFriends() { [weak self] result in
            switch result {
            case .success(let responseFriends):
                let items = responseFriends.items.map {
                    RealmFriend(user: $0)
                }
                DispatchQueue.main.async {
                    do {
                        try RealmService.save(items: items)
                        self?.friends = try RealmService.load(typeOf: RealmFriend.self)
                    } catch {
                        print(error)
                    }
                }
                
//                self?.friends = responseFriends.items
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "showPhoto",
            let indexPath = tableView.indexPathForSelectedRow,
            let destination = segue.destination as? PhotosCollectionVC
        else { return }
    
        let letter = personSectionTitles[indexPath.section]
        let name = personsDictionary[letter]![indexPath.row]

        let person = friends?.first(where: { (i) -> Bool in
            i.lastName == name
        })

        destination.firstname = person?.firstName
        destination.lastname = person?.lastName
        destination.id = person?.id ?? 0
        destination.avatar = person?.photo200 ?? ""
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return personSectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard
            let letter = Optional(personSectionTitles[Optional(section) ?? 0]) ?? nil,
            let names = Optional(personsDictionary[letter]) ?? nil
        else { return 0 }
        
        return names.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendCell,
            let letter = Optional(personSectionTitles[indexPath.section]) ?? nil,
            let lastName = Optional(personsDictionary[letter]![indexPath.row]) ?? nil,
            let firstName = Optional(friends?.first(where: {$0.lastName == lastName})?.firstName) ?? nil,
            let photo = Optional(friends?.first(where: {$0.lastName == lastName})?.photo) ?? nil
        else { return UITableViewCell() }
        
        
        cell.configure(emblem: photo,
                       name: "\(lastName) \(firstName)")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        
        self.performSegue(
                withIdentifier: "showPhoto",
                sender: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard
            let char = Optional(personSectionTitles[section]) ?? nil
        else { return " " }
        return char
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return personSectionTitles
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.tintColor = UIColor.gray.withAlphaComponent(0.1)
    }


}





