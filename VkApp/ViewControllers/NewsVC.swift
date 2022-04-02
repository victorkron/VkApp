//
//  NewsVC.swift
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
    
    private let networkService = Request<News>()
    var userNews = [News]() {
            didSet {
            DispatchQueue.main.async {
                self.NewsTable.reloadData()
            }
        }
    }
    
    var indexOfCell: typeOfCell?
    
    @IBOutlet var NewsTable: UITableView!

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
        
        networkService.fetch(type: .feed) { [weak self] result in
            switch result {
            case .success(let myNews):
                myNews.forEach() { i in
                    guard let attachment = i.contentImages else { return }
                    attachment.forEach { ii in
                        guard ii.type == "photo" else { return }
                        let singleNews = News(
                            sourceID: i.sourceID,
                            text: i.text,
                            date: i.date,
                            contentImages: attachment,
                            likes: i.likes,
                            reposts: i.reposts,
                            comments: i.comments)
                        guard !self!.userNews.contains(singleNews) else { return }
                    self?.userNews.append(singleNews) }
                }
            case .failure(let error):
                print(error)
            }
        }

    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return userNews.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
                
        
//        do {
//            rows = try sections[section].allProperties().count
//        } catch {
//            print("NewsTableVC Error Rows Count")
//        }
        var rows = 4
        if (userNews[section].contentImages == nil) {
            rows -= 1
        }
        if (userNews[section].text == nil || userNews[section].text == "") {
            rows -= 1
        }
        
        return rows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let news = userNews[indexPath.section]
        
        switch indexPath.row {
        case 0:
            indexOfCell = .header
        case 1:
            indexOfCell = (news.text == nil) || (news.text == "") ? .image : .description
        case 2:
            indexOfCell = (news.text == nil) || (news.contentImages == nil) || (news.text == "") ? .footer : .image
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
            
            let group = loadGroup(news.sourceID)
            guard
                let group = group,
                let photo = group.photo
            else {
                return UITableViewCell()
            }
            
            var date = news.date.toString(dateFormat: .day)
            let currentDate = Date().toString(dateFormat: .day)
            if (date == currentDate) {
                let time = news.date.toString(dateFormat: .time)
                date = "Сегодня в \(time)"
            } else {
                date = news.date.toString(dateFormat: .dateTime)
            }
            
            cell.configure(
                photo,
                group.name,
                date)
            
            return cell
            
        case .description:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as? DescriptionCell,
                let text = news.text
            else { return UITableViewCell() }
            
            cell.configure(text)
            
            return cell
            
        case .image:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ImageCell
            else { return UITableViewCell() }
            
            var photos = [String]()
            news.contentImages?.forEach { i in
                guard let photo = i.photo?.sizes.last?.url else { return }
                photos.append(photo)
            }
            
            cell.configure(
                news: news,
                photos: photos)
            
            return cell
            
        case .footer:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "newsActionsCell", for: indexPath) as? newsActionsCell
            else { return UITableViewCell() }
            
            cell.configure(
                likes: news.likes.count,
                comments: news.comments.count,
                reposts: news.reposts.count)
            
            return cell
            
        case .none:
            return UITableViewCell()
            
        }
    }
    
    private func loadGroup(_ id: Int) -> Group? {
        do {
            let realmGroups: [RealmGroup] = try RealmService.load(typeOf: RealmGroup.self).map { $0 }
            if let group = realmGroups.filter({ $0.id == -id }).first {
                return Group(name: group.name, photo: group.photo, id: group.id)
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
    
}
