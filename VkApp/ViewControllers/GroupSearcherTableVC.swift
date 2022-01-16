//
//  GroupTableVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 17.12.2021.
//

import UIKit

class GroupSearcherTableVC: UITableViewController {

    var addedGroup: [Group] = []
    var baseGroups: [Group] = []
    
    var allGroups = [
        Group(name: "Geek"),
        Group(name: "Carrot"),
        Group(name: "X-man")
    ]
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(
                nibName: "GroupCell",
                bundle: nil),
            forCellReuseIdentifier: "groupCell")
        addedGroup.forEach{ (addedGroupItem) in
            if self.allGroups.contains(where: { allGroupsItem in
                allGroupsItem.name == addedGroupItem.name
            }){
                let index = allGroups.firstIndex{ searchingItem in
                    searchingItem.name == addedGroupItem.name
                }
                
                let indexForDelete = index ?? -1
                if (indexForDelete != -1) {
                    allGroups.remove(at: indexForDelete)
                }
            }
        }
        
        baseGroups = allGroups
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell
        else { return UITableViewCell() }
    
        guard
            let currentName = allGroups[indexPath.row].name as? String
        else { return UITableViewCell() }
        
        cell.configure(emblem: UIImage(named: "Groups/\(currentName)") ?? UIImage(),
                       name: currentName)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(
                at: indexPath,
                animated: true)
        }
        
        performSegue(
            withIdentifier: "addGroup",
            sender: nil)
        
    }
    

}

extension GroupSearcherTableVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        allGroups = baseGroups
        
        if (searchText != "") {
            var arr: [Group] = []
            allGroups.forEach{ item in
                if item.name.lowercased().contains(searchText.lowercased()) {
                    arr.append(item)
                } else {
                    
                }
            }
            allGroups = arr
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
