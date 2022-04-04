//
//  NewsVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 15.01.2022.
//

import UIKit

class NewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum NewsCell {
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
    
    var indexOfCell: NewsCell?
    
    @IBOutlet var NewsTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewsTable.delegate = self
        NewsTable.dataSource = self
        
        NewsTable.register(registerClass: AvatarCell.self)
        NewsTable.register(registerClass: DescriptionCell.self)
        NewsTable.register(registerClass: ImageCell.self)
        NewsTable.register(registerClass: newsActionsCell.self)
        
        self.networkService.fetch(type: .feed) { [weak self] result in
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
        
        indexOfCell = getCellType(news: news, for: indexPath)
        
        switch indexOfCell {
        case .header:
            let cell: AvatarCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
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
            
            let cell: DescriptionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            guard
                let text = news.text
            else { return UITableViewCell() }
            
            cell.configure(text)
            
            return cell
            
        case .image:
            
            let cell: ImageCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
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
            
            let cell: newsActionsCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
            cell.configure(
                likes: news.likes.count,
                comments: news.comments.count,
                reposts: news.reposts.count)
            
            return cell
            
        default:
            return UITableViewCell()
        
        }
    }
    
    private func getCellType(news: News ,for item: IndexPath) -> NewsCell? {
        var type: NewsCell
        switch item.item {
        case 0:
            type = .header
        case 1:
            type = (news.text == nil) || (news.text == "") ? .image : .description
        case 2:
            type = (news.text == nil) || (news.contentImages == nil) || (news.text == "") ? .footer : .image
        case 3:
            type = .footer
        default:
            return nil
        }
        return type
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
