//
//  TableViewController.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 20/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView() // 테이블 푸터는 빈 UIView
        tableView.refreshControl = pullToRefresh
        
        refreshActivated() // viewDidLoad에 들어가면 리프레쉬
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
            .map({ URLRequest(url: $0) })
            .flatMap({ URLSession.shared.rx.response(request: $0)})
        
        response.filter({ 200..<300 ~= $0.response.statusCode }) // 스테이터스 200~300 사이에서만 리스폰스를 받는다(그외는 에러)
            .map({ try? JSONDecoder().decode([RepoEvent].self, from: $0.data) })
            .unwrap()
            .subscribe(onNext: { self.process($0) })
            .disposed(by: bag)
    }
    
    func process(_ newEvents: [RepoEvent]) {
        currentEvent = newEvents
        
        if currentEvent.count > 50 {  // 커런트이벤트 수가 50을 넘으면 앞에서부터 50개로 자른다
            currentEvent = Array(currentEvent.prefix(50))
        }
        
        DispatchQueue.main.async { // 데이터 받고 테이블뷰 리프레쉬
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentEvent.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let repoEvent = currentEvent[indexPath.row]
        
        cell.textLabel?.text = repoEvent.actor.username
        cell.detailTextLabel?.text = "\(repoEvent.repo.name)" + repoEvent.type.replacingOccurrences(of: "Event", with: "") // Event를 ""로 바꿔치기
        
        guard let imageUrl = URL(string: repoEvent.actor.imageUrlString) else { return cell }
        
        cell.imageView?.loadImage(with: imageUrl, placeHolder: UIImage(named: "150.jpeg"), bag: bag)
        
        return cell
    }

}
