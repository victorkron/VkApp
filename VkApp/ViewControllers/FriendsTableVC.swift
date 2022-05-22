//
//  FriendsTableVC.swift
//  VkApp
//
//  Created by Карим Руабхи on 17.12.2021.
//

import UIKit
import RealmSwift

final class FriendsTableVC: UITableViewController, ChangeFriendsDatabase{
    
    var personsDictionary = [String: [String]]()
    var personSectionTitles = [String]()
    private var friendsToken: NotificationToken?
    private var netwokService = Request<User>()
    
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        queue.qualityOfService = .utility
        return queue
    }()
    
    private var photoService: PhotoService?
    private var viewModelsFactory: FriendViewModelFactory?
    fileprivate var friendsViewModels: [FriendsViewModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
 
    func refresh(friends: Results<RealmFriend>?) {
        viewModelsFactory?.friends = friends
    }

    @IBAction func celarPhoto(segue: UIStoryboardSegue) {
        // к этому методу привязана анвинд сега, если его убрать, то перехода назад со следующей страницы не будет
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoService = PhotoService(container: self.tableView)
        viewModelsFactory = FriendViewModelFactory(tableView: tableView, source: self)
        
        tableView.register(registerClass: friendCell.self)
        
        setupOperation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        friendsToken = viewModelsFactory?.friends?.observe { [weak self] citiesChanges in
//            switch citiesChanges {
//            case .initial, .update:
//                self?.tableView.reloadData()
//            case .error(let error):
//                print(error)
//            }
//        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard
            let sender = storyBoard.instantiateViewController(withIdentifier: "personCollection") as? PhotosCollectionVC
        else { return }
        DispatchQueue.main.async {
            do {
                guard let photos = sender.photos else { return }
                try RealmService.delete(object: photos)
            } catch {
                print(error)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        friendsToken?.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "showPhoto",
            let indexPath = tableView.indexPathForSelectedRow,
            let destination = segue.destination as? PhotosCollectionVC
        else { return }
    
        let letter = personSectionTitles[indexPath.section]
        let name = personsDictionary[letter]![indexPath.row].components(separatedBy: " ").first

        
        let person = viewModelsFactory?.friends?.first(where: { (i) -> Bool in
            i.lastName == name
        })

        destination.firstname = person?.firstName
        destination.lastname = person?.lastName
        destination.id = person?.id ?? 0
        destination.avatar = person?.photo200 ?? ""
    }

    func setupOperation() {
        let getFriends = RequestBlock(nts: self.netwokService)
        let parseFriendsData = ParseFriendsBlock(block: getFriends)
        let saveToFriendsDatabase = SaveToFriendsDatabase(block: parseFriendsData, delegate: self)

        parseFriendsData.addDependency(getFriends)
        saveToFriendsDatabase.addDependency(parseFriendsData)

        queue.addOperations([getFriends, parseFriendsData, saveToFriendsDatabase], waitUntilFinished: false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return personSectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard
            let letter = Optional(personSectionTitles[Optional(section) ?? 0]) ?? nil,
            let names = Optional(personsDictionary[letter]) ?? nil
        else { return 0 }
        
        return names.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: friendCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard
            let friendCell = cell as? friendCell,
            let viewModel = generateDataForCell(cell: cell, indexPath: indexPath)
        else { return }

        friendCell.configure(friendsModel: viewModel)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        
        self.performSegue(
                withIdentifier: "showPhoto",
                sender: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard
            let char = Optional(personSectionTitles[section]) ?? nil
        else { return " " }
        return char
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return personSectionTitles
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.tintColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    }
    
    func generateDataForCell(cell: UITableViewCell, indexPath: IndexPath) -> FriendsViewModel? {
        guard
            let letter = Optional(personSectionTitles[indexPath.section]) ?? nil,
            let personName = Optional(personsDictionary[letter]![indexPath.row]) ?? nil
        else { return nil }
        
        let viewModel = friendsViewModels.first(where: {$0.name == personName})
        return viewModel
    }
    
}



class RequestBlock: Operation {
    var netwokService: Request<User>
    var responseData: Data?
    
    override func main() {
        self.netwokService.getFriends()
        while self.netwokService.responseData == nil {
            print("wait")
        }
        self.responseData = self.netwokService.responseData
        print("first")
    }
    
    init (nts: Request<User>) {
        self.netwokService = nts
    }
}


class ParseFriendsBlock: Operation {
    var jsonData: Response<User>?
    var block: RequestBlock
    
    override func main() {
        guard let data = block.responseData else { return }
        do {
            jsonData = try JSONDecoder().decode(Response<User>.self, from: data)
            jsonData?.response.items.forEach { user in
            
            }
            print("second")
        } catch {
            print("error")
        }
    }
    
    init (block: RequestBlock) {
        self.block = block
    }
}

class SaveToFriendsDatabase: Operation {
    private var block: ParseFriendsBlock
    var delegate: ChangeFriendsDatabase?
    
    override func main() {
        let itemsOptional = block.jsonData?.response.items.map {
            RealmFriend(user: $0)
        }
        guard let items = itemsOptional else {
            return
        }

        OperationQueue.main.addOperation {
            do {
                try RealmService.save(items: items)
                let friends = try RealmService.load(typeOf: RealmFriend.self)
                self.delegate?.refresh(friends: friends)
                print("third")
            } catch {
                print(error)
            }
        }
    }
    
    init (block: ParseFriendsBlock, delegate: ChangeFriendsDatabase?) {
        self.block = block
        self.delegate = delegate
    }
}

protocol ChangeFriendsDatabase {
    func refresh(friends: Results<RealmFriend>?)
}

protocol UpdateViewModels: AnyObject {
    func updateViewModels()
}

extension FriendsTableVC: UpdateViewModels {
    func updateViewModels () {
        guard
            let viewModels = viewModelsFactory?.viewModels,
            let personsDictionary = viewModelsFactory?.personsDictionary,
            let personSectionTitles = viewModelsFactory?.personSectionTitles
        else { return }
        self.personsDictionary = personsDictionary
        self.personSectionTitles = personSectionTitles
        self.friendsViewModels = viewModels
    }
    
}


