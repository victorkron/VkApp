//
//  GroupTableVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 17.12.2021.
//

import UIKit

class GroupSearcherTableVC: UITableViewController {

    var addedGroup: [GroupData] = []
    var baseGroups: [GroupData] = []
    private var networkService = RequestProxy(request: Request<GroupData>())
    
    var allGroups: [GroupData] = [] {
        didSet {
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var timer = Timer()
    
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(registerClass: groupCell.self)
        
        baseGroups = allGroups
        
        networkService.fetch(type: .searchGroups) { [weak self] result in
            switch result {
            case .success(let myGroups):
                myGroups.forEach() { i in
                    print(i)
                    self?.allGroups.append(GroupData(
                        id: i.id,
                        name: i.name,
                        photo: i.photo))
                }

            case .failure(let error):
                print(error)
            }

        }

        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: groupCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
    
        let currentName = allGroups[indexPath.row].name
        let currentPhoto = allGroups[indexPath.row].photo
        
        cell.configure(
            emblem: currentPhoto,
            name: currentName
        )

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(
                at: indexPath,
                animated: true
            )
        }
        
        performSegue(
            withIdentifier: "addGroup",
            sender: nil)
        
    }
    

}

extension GroupSearcherTableVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { _ in
            if (searchText != "") {
                self.networkService.fetch(type: .searchGroups, str: searchText) { [weak self] result in
                    switch result {
                    case .success(let myGroups):
                        self?.allGroups = []
                        myGroups.forEach() { i in
                            print(i)
                            self?.allGroups.append(GroupData(
                                id: i.id,
                                name: i.name,
                                photo: i.photo))
                        }
                    case .failure(let error):
                        print(error)
                    }

                }
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
