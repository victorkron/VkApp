//
//  FriendsTableVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 17.12.2021.
//

import UIKit

final class FriendsTableVC: UITableViewController {
    
    var personsDictionary = [String: [String]]()
    var personSectionTitles = [String]()

    var persons: [User] = [
        User(name: "John",
             surname: "Black",
             age: 27,
             photosArr: ["caption1", "caption2", "caption3", "caption4", "caption5"]),
        User(name: "Emma",
             surname: "Heisenberg",
             age: 22,
             photosArr: ["caption1", "caption2", "caption3", "caption4", "caption5"]),
        User(name: "Robert",
             surname: "Gray",
             age: 35,
             photosArr: ["caption1", "caption2", "caption3", "caption4", "caption5"]),
        User(name: "Eli",
             surname: "White",
             age: 23,
             photosArr: ["caption1", "caption2", "caption3", "caption4", "caption5"]),
        User(name: "Nicole",
             surname: "Smith",
             age: 32,
             photosArr: ["caption1", "caption2", "caption3", "caption4", "caption5"])
    ]
//
    
    // MARK: - Lifecycle
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(
                nibName: "FriendCell",
                bundle: nil),
            forCellReuseIdentifier: "friendCell")
        
        for person in persons {
            let personKey = String(person.fullname.prefix(1))
            if var personsValue = personsDictionary[personKey] {
                personsValue.append(person.fullname)
                personsDictionary[personKey] = personsValue
            } else {
                personsDictionary[personKey] = [person.fullname]
            }
        }
        
        personSectionTitles = [String](personsDictionary.keys)
        personSectionTitles = personSectionTitles.sorted(by: { $0 < $1 })
        for eachGroupNames in personsDictionary {
            personsDictionary[eachGroupNames.key] = eachGroupNames.value.sorted(by: { $0 < $1 })
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "showPhoto",
            
            let indexPath = tableView.indexPathForSelectedRow
        else { return }
        
        guard
            let destination = segue.destination as? PhotosCollectionVC
        else { return }
        
        let letter = personSectionTitles[indexPath.section]
        let name = personsDictionary[letter]![indexPath.row]
        
        destination.personName = name
        let person = persons.first(where: { (i) -> Bool in
            i.fullname == name
        })
        
        destination.firstname = person?.firstname
        destination.lastname = person?.lastname
        destination.personAge = person?.age
        destination.photos = person?.photos
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return personSectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let letter = personSectionTitles[section]
        guard let names = personsDictionary[letter] else { return 0 }
        
        return names.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendCell
        else { return UITableViewCell() }
        
        let letter = personSectionTitles[indexPath.section]
        let currentName = personsDictionary[letter]![indexPath.row]
        
        cell.configure(emblem: UIImage(named: "Friends/\(currentName)") ?? UIImage(),
                       name: currentName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        
        self.performSegue(
                withIdentifier: "showPhoto",
                sender: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return personSectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return personSectionTitles
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.tintColor = UIColor.gray.withAlphaComponent(0.1)
    }


}





