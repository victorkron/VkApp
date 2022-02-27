//
//  GroupsTableVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 17.12.2021.
//

import UIKit
import RealmSwift

final class GroupsTableVC: UITableViewController {
    
    
    var groups: Results<RealmGroup>? = try? RealmService.load(typeOf: RealmGroup.self) {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
//    var groups: [Group] = []
//    {
//        didSet {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//        
//    }

    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard
            segue.identifier == "addGroup",
            let allGroupsController = segue.source as? GroupSearcherTableVC,
            let groupIndexPath = allGroupsController.tableView.indexPathForSelectedRow
//            !self.groups.contains(allGroupsController.allGroups[groupIndexPath.row])
        else { return }
//
//        guard
//            self.groups != nil
//        else { return }
//
//        for item in self.groups {
//            if (item.name == allGroupsController.allGroups[groupIndexPath.row].name) {
//                return
//            }
//        }
//
//        let item = RealmGroup(group: allGroupsController.allGroups[groupIndexPath.row])
//
//        do {
//            try RealmService.add(item: <#T##T#>)
//        } catch {
//            print(error)
//        }
//        groups.append(allGroupsController.allGroups[groupIndexPath.row]) // ИСПРАВИТЬ!!!!!!!!
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
        tableView.register(
            UINib(
                nibName: "GroupCell",
                bundle: nil),
            forCellReuseIdentifier: "groupCell")
        
        let request = Request()
        request.getGroups() { [weak self] result in
            switch result {
            case .success(let myGroups):
                let items = myGroups.items.map { i in
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
//                myGroups.items.forEach() { i in
//                    print(i)
//                    self?.groups.append(Group(
//                        name: i.name,
//                        photo: i.photo))
//                }

            case .failure(let error):
                print(error)
            }

        }
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
        return groups?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell
        else { return UITableViewCell() }

        let currentName = groups?[indexPath.row].name ?? ""
        let currentPhoto = groups?[indexPath.row].photo ?? ""
        
        cell.configure(emblem: currentPhoto,
                       name: currentName)
        print(currentName)
        return cell
    }
    
    

    // Override to support editing the table view.
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
//

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
