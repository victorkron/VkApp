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
             age: 27,
             photosArr: ["caption1", "caption2", "caption3", "caption4", "caption5"]),
        User(name: "Emma",
             age: 22,
             photosArr: ["caption1", "caption2", "caption3", "caption4", "caption5"]),
        User(name: "Robert",
             age: 35,
             photosArr: ["caption1", "caption2", "caption3", "caption4", "caption5"]),
        User(name: "Eli",
             age: 23,
             photosArr: ["caption1", "caption2", "caption3", "caption4", "caption5"]),
        User(name: "Nicole",
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
            let personKey = String(person.name.prefix(1))
            if var personsValue = personsDictionary[personKey] {
                personsValue.append(person.name)
                personsDictionary[personKey] = personsValue
            } else {
                personsDictionary[personKey] = [person.name]
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
            i.name == name
        })
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
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            defer { tableView.deselectRow(at: indexPath, animated: true) }
        performSegue(
            withIdentifier: "showPhoto",
            sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return personSectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return personSectionTitles
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
