//
//  TableViewController.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 20/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa
import RxSwiftExt

class TableViewController: UITableViewController {
    
    lazy var pullToRefresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(refreshActivated), for: .valueChanged)
        return refresh
    }()
    
    let bag = DisposeBag()
    var currentEvent = [RepoEvent]()
    
    lazy var fetchedRC: NSFetchedResultsController<Event> = {
        let request = Event.fetchRequest() as NSFetchRequest<Event>
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Event.id), ascending: false)]
        
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext,
            sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView() // 테이블 푸터는 빈 UIView
        tableView.refreshControl = pullToRefresh
        
        fetchCoreData()
        
        refreshActivated() // viewDidLoad에 들어가면 리프레쉬
    }
    
    func fetchCoreData() {
        do {
            try fetchedRC.performFetch()
            let count = fetchedRC.sections?.first?.objects?.count ?? 0
            
            for row in 0..<count {
                let index = IndexPath(row: row, section: 0)
                let event = fetchedRC.object(at: index)
                
                let repo = Repo.init(name: event.repoName)
                let actor = Actor.init(username: event.userName, imageUrlString: event.imageUrl.absoluteString)
                let repoEvent = RepoEvent.init(id: String(event.id), type: event.type, actor: actor, repo: repo)
                
                self.currentEvent.append(repoEvent)
            }
        }
        catch { print(error.localizedDescription) }
    }

    @objc func refreshActivated() {
        DispatchQueue.global(qos: .background).async {
            self.fetchEvents(for: "ReactiveX/RxSwift")
        }
    }
    
    func fetchEvents(for repoName: String) {
        let response = Observable.just(repoName)
            .map({ URL(string: "https://api.github.com/repos/\($0)/events") })
            .unwrap()
            .map({ (url) -> URLRequest in
                var request = URLRequest(url: url)
                
                if let date = UserDefaults.standard.value(forKey: "lastModified") as? String {
                    request.addValue(date, forHTTPHeaderField: "If-Modified-Since")
                    request.cachePolicy = .reloadIgnoringLocalCacheData
                }
                
                return request
            })
//            .map({ URLRequest(url: $0) })
            .flatMap({ URLSession.shared.rx.response(request: $0)})
            .share(replay: 1, scope: .whileConnected)
        
        response.filter({ 200..<300 ~= $0.response.statusCode }) // 스테이터스 200~300 사이에서만 리스폰스를 받는다(그외는 에러)
            .map({ try? JSONDecoder().decode([RepoEvent].self, from: $0.data) })
            .unwrap()
            .subscribe(onNext: { self.process($0) },
                       onDisposed: { DispatchQueue.main.async { self.refreshControl?.endRefreshing() } })
            .disposed(by: bag)
        
        response
            .filter({ 200..<400 ~= $0.response.statusCode })
            .map({ $0.response.allHeaderFields["Last-Modified"] })
            .unwrap()
            .subscribe(onNext: { UserDefaults.standard.set($0, forKey: "lastModified") })
            .disposed(by: bag)
    }
    
    func process(_ newEvents: [RepoEvent]) {
        currentEvent += newEvents
        
        currentEvent.sort(by: { (Int64($0.id) ?? 0) > (Int64($1.id) ?? 0) })
        
        if currentEvent.count > 50 {  // 커런트이벤트 수가 50을 넘으면 앞에서부터 50개로 자른다
            currentEvent = Array(currentEvent.prefix(50))
        }
        
        DispatchQueue.main.async { // 데이터 받고 테이블뷰 리프레쉬
            self.clearCoreData()
            self.insertCoreData(with: self.currentEvent)
            self.refreshControl?.endRefreshing()
        }
    }
    
    func clearCoreData() {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let request = Event.fetchRequest() as NSFetchRequest<Event>
        
        do {
            let objects = try context.fetch(request)
            _ = objects.map{ context.delete($0) }
            try context.save()
        }
        catch { print(error.localizedDescription) }
    }
    
    func insertCoreData(with repoEvents: [RepoEvent]) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        for repoEvent in repoEvents {
            let event = Event(context: context)
            event.id = Int64(repoEvent.id) ?? 0
            event.repoName = repoEvent.repo.name
            event.type = repoEvent.type
            event.userName = repoEvent.actor.username
            event.imageUrl = URL(string: repoEvent.actor.imageUrlString)!
        }
        
        do { try context.save() }
        catch{ print(error.localizedDescription) }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedRC.sections?.first?.objects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        let repoEvent = currentEvent[indexPath.row]
        
        let event = fetchedRC.object(at: indexPath)
        
        cell.textLabel?.text = event.userName
        cell.detailTextLabel?.text = "\(event.repoName)" + event.type.replacingOccurrences(of: "Event", with: "") // Event를 ""로 바꿔치기
        
//        guard let imageUrl = URL(string: repoEvent.actor.imageUrlString) else { return cell }
        
        cell.imageView?.loadImage(with: event.imageUrl, placeHolder: UIImage(named: "150.jpeg"), bag: bag)
        
        return cell
    }

}

extension TableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete: tableView.deleteRows(at: [indexPath!], with: .fade)
        default: break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
