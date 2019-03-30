//
//  CategoryTableViewController.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 30/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryTableViewController: UITableViewController {

    let relay = BehaviorRelay<[EOCategory]>(value: [])
    let bag = DisposeBag()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .black
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "All Categories"
        
        tableView.addSubview(activityIndicator)
        activityIndicator.center = tableView.center
        activityIndicator.startAnimating()
        tableView.tableFooterView = UIView()
        
        relay.subscribe(onNext: { [weak self] (_) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }).disposed(by: bag)
        
        startDownload()
    }

    func startDownload() {
        // Practice Part 2
        let eoCategories = EONET.eoCategories
        let eoEvents = EONET.events()
        let updatedCategories = Observable.combineLatest(eoCategories, eoEvents) { (categories, events) -> [EOCategory] in
            return categories.map({ (category) -> EOCategory in
                var cat = category
                cat.events = events.filter({ $0.categories.contains{ $0.id == category.id } })
                return cat
            }).sorted(by: { $0.events.count > $1.events.count })
        }
        
        eoCategories.concat(updatedCategories).do(onCompleted: { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }).bind(to: relay).disposed(by: bag)
        
        // Practice Part 1
//        EONET.eoCategories.do(onCompleted: { [weak self] in  // eoCategories 일이 끝나면(파싱) 액티비티 인디케이터 스탑
//            DispatchQueue.main.async {
//                self?.activityIndicator.stopAnimating()
//            }
//        }).bind(to: relay).disposed(by: bag)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return relay.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = relay.value[indexPath.row]
        cell.textLabel?.text = "\(category.title) (\(category.events.count))"
        cell.detailTextLabel?.text = category.description
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = category.events.count > 0 ? .disclosureIndicator : .none
        
        return cell
    }
}
