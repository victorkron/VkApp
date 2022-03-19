//
//  GroupsTableVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 17.12.2021.
//

import UIKit
import RealmSwift
import FirebaseDatabase

final class GroupsTableVC: UITableViewController {
    
    
    private var groups = [FirebaseGroup]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    private let reference = Database.database().reference()
    
//    private var groupsToken: NotificationToken?
//
//    private var groups: Results<RealmGroup>? = try? RealmService.load(typeOf: RealmGroup.self) {
//        didSet {
//            DispatchQueue.main.async {
////                self.tableView.reloadData()
//            }
//        }
//    }

//    @IBAction func addGroup(segue: UIStoryboardSegue) {
//        guard
//            segue.identifier == "addGroup",
//            let allGroupsController = segue.source as? GroupSearcherTableVC,
//            let groupIndexPath = allGroupsController.tableView.indexPathForSelectedRow
//        else { return }
//        do {
//            let item = RealmGroup(group: allGroupsController.allGroups[groupIndexPath.row])
//            self.groups?.forEach{ i in
//                if (i.id == item.id) {
//                    return
//                }
//            }
//            try RealmService.add(item: item)
//            self.groups = try RealmService.load(typeOf: RealmGroup.self)
//        } catch {
//            print(error)
//        }
//        tableView.reloadData()
//    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(
                nibName: "GroupCell",
                bundle: nil),
            forCellReuseIdentifier: "groupCell")
        
        self.reference.observe(
            .value) { snapshot in
                var currentGroup = [FirebaseGroup]()
                snapshot.children.forEach { [weak self] i in
                    guard let self = self else { return }
                    guard
                        let childSnap = i as? DataSnapshot,
                        let group = FirebaseGroup(snapshot: childSnap)
                    else { return }
                    currentGroup.append(group)
                    self.groups.append(group)
                }
                self.groups = currentGroup
                self.tableView.reloadData()
            }
        
        let request = Request()
        request.getGroups() { [weak self] result in
            switch result {
            case .success(let myGroups):
                guard let self = self else { return }
                let items = myGroups.items.map { i in
                    FirebaseGroup(id: i.id, name: i.name, photo: i.photo)
                }
                DispatchQueue.main.async {
                    items.forEach { i in
                        print(i.name)
                        self.reference
                            .child(String(i.id)).child("name").setValue(i.name)
                        self.reference
                            .child(String(i.id)).child("photo").setValue(i.photo)
                    }
                }
                

            case .failure(let error):
                print(error)
            }

            
        }
        
        
        
//        let request = Request()
//        request.getGroups() { [weak self] result in
//            switch result {
//            case .success(let myGroups):
//                let items = myGroups.items.map { i in
//                    RealmGroup(group: i)
//                }
//                DispatchQueue.main.async {
//                    do {
//                        try RealmService.save(items: items)
//                        self?.groups = try RealmService.load(typeOf: RealmGroup.self)
//                    } catch {
//                        print(error)
//                    }
//                }
//
//            case .failure(let error):
//                print(error)
//            }
//
//        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        groupsToken = groups?.observe { [weak self] groupsChange in
//            switch groupsChange {
//            case .initial, .update:
//                self?.tableView.reloadData()
////            case .update(
////                _,
////                deletions: let deletions,
////                insertions: let insertions,
////                modifications: let modifications):
////                print(deletions, insertions, modifications)
//            case .error(let error):
//                print(error)
//            }
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(groups)
        groups.forEach { i in
            i.reference?.removeValue()
        }
//        groupsToken?.invalidate()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard
//            segue.identifier == "showAllGroups"
//        else { return }
//
//        guard
//            let destination = segue.destination as? GroupSearcherTableVC
//        else { return }
//
//        destination.addedGroup = groups
//    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell
        else { return UITableViewCell() }
        print(groups)

        let currentName = groups[indexPath.row].name ?? ""
        let currentPhoto = groups[indexPath.row].photo ?? ""
        
        cell.configure(emblem: currentPhoto,
                       name: currentName)
    
        return cell
    }
    
    

    // Override to support editing the table view.
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let group = groups[indexPath.row]
            tableView.deleteRows(
                at: [indexPath],
                with: .fade)
            group.reference?.removeValue()
        }
            
    }

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
