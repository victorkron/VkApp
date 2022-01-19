//
//  NewsTableVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 15.01.2022.
//

import UIKit

class NewsTableVC: UITableViewController {
    

    var sections: [News] = [
        News(
            Title(
                UIImage(named: "Image"),
                "Nick"
            ),
            nil,
            UIImage(named: "diagram"),
            ActionsData(10, 2, 3, 121)
        ),
        News(
            Title(
                UIImage(named: "landscape"),
                "BBC"
            ),
            "Tempore accusamus ab ipsa provident dolores rem consequatur, rerum, atque delectus fugiat est perferendis.",
            nil,//UIImage(named: "restaurant"),
            ActionsData(73, 13, 22, 574)
        ),
        News(
            nil,
            "Tempore accusamus ab ipsa provident dolores rem consequatur, rerum, atque delectus fugiat est perferendis.",
            nil,//UIImage(named: "restaurant"),
            ActionsData(2, 0, 1, 132)
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(
                nibName: "AvatarCell",
                bundle: nil),
            forCellReuseIdentifier: "avatarCell")
        
        tableView.register(
            UINib(
                nibName: "DescriptionCell",
                bundle: nil),
            forCellReuseIdentifier: "descriptionCell")
        
        tableView.register(
            UINib(
                nibName: "ImageCell",
                bundle: nil),
            forCellReuseIdentifier: "imageCell")
        
        tableView.register(
            UINib(
                nibName: "newsActionsCell",
                bundle: nil),
            forCellReuseIdentifier: "newsActionsCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
                
        var rows = 0
        do {
            rows = try sections[section].allProperties().count
        } catch {
            print("NewsTableVC Error Rows Count")
        }
        
        return rows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        switch indexPath.row {
        case 0:
            guard ((sections[indexPath.section].title) != nil) else { break }
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "avatarCell", for: indexPath) as? AvatarCell
            else { return UITableViewCell() }
            cell.configure(
                sections[indexPath.section].title?.avatar,
                sections[indexPath.section].title?.name ?? "undefinedName"
            )
            return cell
            
        case 1:
            guard ((sections[indexPath.section].description) != nil) else { break }
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as? DescriptionCell
            else { return UITableViewCell() }
            cell.configure(
                sections[indexPath.section].description ?? "undefinedDescription"
            )
            
            return cell
        case 2:
            guard ((sections[indexPath.section].contentImage) != nil) else { break }
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ImageCell
            else { return UITableViewCell() }
            cell.configure(
                sections[indexPath.section].contentImage
            )
            return cell
        case 3:
            guard ((sections[indexPath.section].dataOfActions) != nil) else { break }
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "newsActionsCell", for: indexPath) as? newsActionsCell
            else { return UITableViewCell() }
            cell.configure(
                sections[indexPath.section].dataOfActions!
                
            )
            return cell
        default:
            return UITableViewCell()
        }
        
        
        
        return UITableViewCell()

        
    }
    
    
//    descriptionCell
    

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
