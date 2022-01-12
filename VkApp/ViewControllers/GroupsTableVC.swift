//
//  GroupsTableVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 17.12.2021.
//

import UIKit

final class GroupsTableVC: UITableViewController {
    
    var groups: [Group] = []
//    {
//        didSet {
//            tableView.reloadData()
//        }
//    }

    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard
            segue.identifier == "addGroup",
            let allGroupsController = segue.source as? GroupSearcherTableVC,
            let groupIndexPath = allGroupsController.tableView.indexPathForSelectedRow
//            !self.groups.contains(allGroupsController.allGroups[groupIndexPath.row])
        else { return }
        
        for item in self.groups {
            if (item.name == allGroupsController.allGroups[groupIndexPath.row].name) {
                return
            }
        }
        
        self.groups.append(allGroupsController.allGroups[groupIndexPath.row])
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "showAllGroups"
        else { return }

        guard
            let destination = segue.destination as? GroupSearcherTableVC
        else { return }
        
        destination.addedGroup = groups
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell
        else { return UITableViewCell() }

        let currentName = groups[indexPath.row].name
        
        cell.configure(emblem: UIImage(named: "Groups/\(currentName)") ?? UIImage(),
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
            groups.remove(at: indexPath.row)
            tableView.deleteRows(
                at: [indexPath],
                with: .fade)
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
