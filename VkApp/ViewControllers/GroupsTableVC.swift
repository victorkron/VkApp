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
    
//    private var basedNetworkService = Request<GroupData>()
    private var networkService = RequestProxy(request: Request<GroupData>())
    
    private var viewModelsFactory: GroupViewModelFactory? = GroupViewModelFactory()
    fileprivate var groupsViewModels: [GroupViewModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var photoService: PhotoService?
    
    private var groups: Results<RealmGroup>? = try? RealmService.load(typeOf: RealmGroup.self) {
        didSet {
            guard let photoService = photoService else { return }
            groupsViewModels = viewModelsFactory?.getModels(groups: groups, photoService: photoService) ?? []
        }
    }

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
    
    func updateGroups() {
        do {
            self.groups = try RealmService.load(typeOf: RealmGroup.self)
        } catch {
            print("Load Realm")
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelsFactory = GroupViewModelFactory()
        
        photoService = PhotoService(container: tableView)
        
        tableView.register(registerClass: groupCell.self)
    
        networkService.fetch(type: .groups){ [weak self] result in
            switch result {
            case .success(let myGroups):
                let items = myGroups.map { i in
                    RealmGroup(group: i)
                }
                DispatchQueue.main.async {
                    do {
                        try RealmService.save(items: items)
                        self?.groups = try RealmService.load(typeOf: RealmGroup.self)
                    } catch {
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsViewModels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: groupCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(group: groupsViewModels[indexPath.row])
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
