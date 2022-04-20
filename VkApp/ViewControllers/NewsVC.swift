//
//  NewsVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 15.01.2022.
//

import UIKit

class NewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UpdateTableView {
  
    enum NewsCell {
        case header
        case description
        case image
        case footer
    }
    
    private var nextFrom = ""
    var isLoading = false
    private var lastDateString: String?
    private let networkService = Request<News>()
    var userNews = [News]() {
            didSet {
            DispatchQueue.main.async {
                self.newsTable.reloadData()
            }
        }
    }
    
    var indexOfCell: NewsCell?
    
    @IBOutlet var newsTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTable.delegate = self
        newsTable.dataSource = self
        newsTable.prefetchDataSource = self
        
        cellsRegistering()
        feedRequest()
        setupRefreshControl()
    }
    
    func updateTV(index: IndexPath) {
        newsTable.reloadRows(at: [[index.section, index.row]], with: .fade)
    }
    
    fileprivate func setupRefreshControl() {
        newsTable.refreshControl = UIRefreshControl()
        newsTable.refreshControl?.attributedTitle = NSAttributedString(string: "Спокойствие...")
        newsTable.refreshControl?.tintColor = .black
        newsTable.refreshControl?.addTarget(
            self,
            action: #selector(refreshNews),
            for: .valueChanged
        )
    }
    
    @objc func refreshNews() {
        newsTable.refreshControl?.beginRefreshing()
        lastDateString = String(self.userNews.first?.date.timeIntervalSinceReferenceDate ?? Date().timeIntervalSince1970)
        guard
            let getLastDate = lastDateString,
            let nextMoment = Double(getLastDate)
        else { return }
        let timeSince = String(nextMoment + 1)
        networkService.getNews(timeSince: timeSince) { [weak self] news in
            DispatchQueue.main.async {
                self?.newsTable.refreshControl?.endRefreshing()
            }
            switch news {
            case .success(let myNews):
                guard myNews.count > 0 else { return }
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
                            comments: i.comments
                        )
                        
                        guard !self!.userNews.contains(singleNews) else { return }
                        self?.userNews.insert(singleNews, at: 0)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func cellsRegistering() {
        newsTable.register(registerClass: AvatarCell.self)
        newsTable.register(registerClass: DescriptionCell.self)
        newsTable.register(imageTVCell.self, forCellReuseIdentifier: imageTVCell.identifier)
        newsTable.register(registerClass: ImageCell.self)
        newsTable.register(registerClass: newsActionsCell.self)
    }

    func feedRequest() {
        networkService.getNews { [weak self] result in
            switch result {
            case .success(let newsData):
                print(newsData)
                newsData.response.items.forEach() { i in
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
                self?.nextFrom = newsData.response.nextFrom
            case .failure(let error):
                print(error)
            }
        }
    }

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
            
            cell.configure(text, source: self, indexPath)
            
            return cell
            
        case .image:
            var photos = [String]()
            news.contentImages?.forEach { i in
                guard let photo = i.photo?.sizes.last?.url else { return }
                photos.append(photo)
            }
            
            if photos.count == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: imageTVCell.identifier) as! imageTVCell
                cell.configure(photos[0])
                return cell
            } else if photos.count > 1 {
                let cell: ImageCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configure(news: news, photos: photos)
                return cell
            } else {
                return UITableViewCell()
            }
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let news = userNews[indexPath.section]
        indexOfCell = getCellType(news: news, for: indexPath)
        switch indexOfCell {
        case .image:
            guard
                let urls = news.contentImages,
                !urls.isEmpty
            else { return 0.0 }
            let count = urls.count

            if  count == 1 {
                let width = view.frame.width
                let post = userNews[indexPath.section]
                let cellHeight = width * post.aspectRatio
                return cellHeight
            } else {
                print("more")
            }
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }

    
    private func getCellType(news: News ,for item: IndexPath) -> NewsCell? {
        var type: NewsCell
        switch item.row {
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


extension NewsVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard
            let maxSection = indexPaths.map({ $0.section }).max()
        else { return }

        if maxSection > userNews.count - 3,
            !isLoading {
            isLoading = true
            networkService.getNews(nextFrom: nextFrom) { [weak self] result in
                switch result {
                case .success(let newsData):
                    print(newsData)
                    newsData.response.items.forEach() { i in
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
                    self?.nextFrom = newsData.response.nextFrom
                case .failure(let error):
                    print(error)
                }
                self?.isLoading = false
            }
        }
    }
}


protocol UpdateTableView {
    func updateTV(index: IndexPath)
}
