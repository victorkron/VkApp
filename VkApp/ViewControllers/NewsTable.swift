//
//  NewsTableVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 15.01.2022.
//

import UIKit

class NewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum typeOfCell {
        case header
        case description
        case image
        case footer
    }
    
    var indexOfCell: typeOfCell?
    
    @IBOutlet var NewsTable: UITableView!
    var sections: [News] = [
        News(
            Title(
                UIImage(named: "landscape"),
                "BBC"
            ),
            "Tempore accusamus ab ipsa provident dolores rem consequatur, rerum, atque delectus fugiat est perferendis.",
            UIImage(named: "restaurant"),
            ActionsData(73, 13, 22, 574)
        ),
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
            Title(
                UIImage(named: "landscape"),
                "BBC"
            ),
            "Tempore accusamus ab ipsa provident dolores rem consequatur, rerum, atque delectus fugiat est perferendis.",
            UIImage(named: "diagram"),//UIImage(named: "restaurant"),
            ActionsData(73, 13, 22, 574)
        ),
        News(
            Title(
                UIImage(named: "restaurant"),
                "RBC"
            ),
            "Tempore accusamus ab ipsa provident dolores rem consequatur, rerum, atque delectus fugiat est perferendis.",
            nil,//UIImage(named: "restaurant"),
            ActionsData(2, 0, 1, 132)
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewsTable.delegate = self
        NewsTable.dataSource = self
        
        NewsTable.register(
            UINib(
                nibName: "AvatarCell",
                bundle: nil),
            forCellReuseIdentifier: "avatarCell")
        
        NewsTable.register(
            UINib(
                nibName: "DescriptionCell",
                bundle: nil),
            forCellReuseIdentifier: "descriptionCell")
        
        NewsTable.register(
            UINib(
                nibName: "ImageCell",
                bundle: nil),
            forCellReuseIdentifier: "imageCell")
        
        NewsTable.register(
            UINib(
                nibName: "newsActionsCell",
                bundle: nil),
            forCellReuseIdentifier: "newsActionsCell")

    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
                
        
//        do {
//            rows = try sections[section].allProperties().count
//        } catch {
//            print("NewsTableVC Error Rows Count")
//        }
        var rows = 4
        if (sections[section].contentImage == nil) {
            rows -= 1
        }
        if (sections[section].description == nil) {
            rows -= 1
        }
        if (sections[section].dataOfActions == nil) {
            rows -= 1
        }
        if (sections[section].title == nil) {
            rows -= 1
        }
        
        return rows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let news = sections[indexPath.section]
        
        switch indexPath.row {
        case 0:
            indexOfCell = .header
        case 1:
            indexOfCell = (news.description == nil) ? .image : .description
        case 2:
            indexOfCell = (news.description == nil) || news.contentImage == nil ? .footer : .image
        case 3:
            indexOfCell = .footer
        default:
            indexOfCell = .none
        }
        
        switch indexOfCell {
            
        case .header:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "avatarCell", for: indexPath) as? AvatarCell
            else { return UITableViewCell() }
            
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            
            cell.configure(
                news.title?.avatar,
                news.title?.name ?? "undefinedName",
                "\(hour):\(minute)"
            )
            
            return cell
            
        case .description:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as? DescriptionCell
            else { return UITableViewCell() }
            
            cell.configure(
                news.description ?? "undefinedDescription"
            )
            
            return cell
            
        case .image:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ImageCell
            else { return UITableViewCell() }
            
            cell.configure(
                news.contentImage
            )
            
            return cell
            
        case .footer:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "newsActionsCell", for: indexPath) as? newsActionsCell
            else { return UITableViewCell() }
            
            cell.configure(
                news.dataOfActions!
                
            )
            
            return cell
            
        case .none:
            return UITableViewCell()
            
        }
    }
    
}
