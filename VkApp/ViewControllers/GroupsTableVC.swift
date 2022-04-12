//
//  GroupsTableVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 17.12.2021.
//

import UIKit
import RealmSwift
import SwiftUI
import PromiseKit

fileprivate enum GroupsError: Error {
    case loadError
}

final class GroupsTableVC: UITableViewController, UpdateGroupsFromRealm {
    
    private var groupsToken: NotificationToken?
    private var networkService = Request<GroupData>()
    
    private var photoService: PhotoService?
    
    private var groups: Results<RealmGroup>? = try? RealmService.load(typeOf: RealmGroup.self) 

    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard
            segue.identifier == "addGroup",
            let allGroupsController = segue.source as? GroupSearcherTableVC,
            let groupIndexPath = allGroupsController.tableView.indexPathForSelectedRow
        else { return }
        do {
            let item = RealmGroup(group: allGroupsController.allGroups[groupIndexPath.row])
            self.groups?.forEach{ i in
                if (i.id == item.id) {
                    return
                }
            }
            try RealmService.add(item: item)
            self.groups = try RealmService.load(typeOf: RealmGroup.self)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoService = PhotoService(container: tableView)
        tableView.register(
            UINib(
                nibName: "GroupCell",
                bundle: nil),
            forCellReuseIdentifier: "groupCell")
        
        networkService.getGroupsUrl()
            .then(on: .global(), networkService.getGroups(url:))
            .then(networkService.getParsedData(data:))
            .then({ groupsArray in
                self.networkService.saveToGroupsDatabse(groups: groupsArray, desination: self)
            })
            .done(on: .main) { result in
                print(result)
            }
            .catch { error in
                print(error)
            }
    }
    
    func updateGroups() {
        do {
            self.groups = try RealmService.load(typeOf: RealmGroup.self)
        } catch {
            print("Load Realm")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        groupsToken = groups?.observe { [weak self] groupsChange in
            switch groupsChange {
            case .initial, .update:
                self?.tableView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        groupsToken?.invalidate()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell
        else { return UITableViewCell() }

        let currentName = groups?[indexPath.row].name ?? ""
        let currentPhoto = groups?[indexPath.row].photo ?? ""
        let photo = photoService?.photo(atIndexPath: indexPath, byUrl: currentPhoto)
        
        cell.configure(image: photo, name: currentName)

        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
            
        if editingStyle == .delete {
            do {
                guard
                    let group = groups?[indexPath.row]
                else { return }
                try RealmService.delete(object: group)
                self.groups = try RealmService.load(typeOf: RealmGroup.self)
            } catch {
                print(error)
            }
            tableView.deleteRows(
                at: [indexPath],
                with: .fade)
        }
    }
}


protocol UpdateGroupsFromRealm {
    func updateGroups()
}
