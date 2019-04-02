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
    
    let categoryRelay = BehaviorRelay<[EOCategory]>(value: [])
    //    let relay = BehaviorRelay<[EOCategory]>(value: [])
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
        
        categoryRelay.subscribe(onNext: { [weak self] (_) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }).disposed(by: bag)
        
        startDownload()
    }
    
    func startDownload() {
        // Practice Part 2
        let eoCategories = EONET.eoCategories
        //        let eoEvents = EONET.events()
        //        let updatedCategories = Observable.combineLatest(eoCategories, eoEvents) { (categories, events) -> [EOCategory] in
        //            return categories.map({ (category) -> EOCategory in
        //                var cat = category
        //                cat.events = events.filter({ $0.categories.contains{ $0.id == category.id } }).sorted(by: { $0.title < $1.title })
        //                return cat
        //            }).sorted(by: { $0.events.count > $1.events.count })
        //        }
        
        let eventsPerCategory = eoCategories.flatMap { (categories) -> Observable<Observable<[EOEvent]>> in
            return self.events(from: categories)
            }.merge(maxConcurrent: 2)
        
        let updatedCategories = eoCategories.flatMap { (categories) -> Observable<[EOCategory]> in
            return self.updateNCombine(categories: categories, with: eventsPerCategory)
        }
        
        eoCategories.concat(updatedCategories).do(onCompleted: { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }).bind(to: categoryRelay).disposed(by: bag)
        
        // Practice Part 1
        //        EONET.eoCategories.do(onCompleted: { [weak self] in  // eoCategories 일이 끝나면(파싱) 액티비티 인디케이터 스탑
        //            DispatchQueue.main.async {
        //                self?.activityIndicator.stopAnimating()
        //            }
        //        }).bind(to: relay).disposed(by: bag)
    }
    
    func events(from categories: [EOCategory]) -> Observable<Observable<[EOEvent]>> {
        let map = categories.map { (category) -> Observable<[EOEvent]> in
            return EONET.events(categoryID: category.id)
        }
        return Observable.from(map)
    }
    
    func updateNCombine(categories: [EOCategory], with events: Observable<[EOEvent]>) -> Observable<[EOCategory]> {
        return events.scan(categories, accumulator: { (summery, next) -> [EOCategory] in
            return self.update(categories: summery, with: next)
        })
    }
    
    func update(categories: [EOCategory], with events: [EOEvent]) -> [EOCategory] {
        return categories.map({ (category) -> EOCategory in
            
            let newEvents = events.filter({ (event) -> Bool in
                return event.categories.contains(where: { $0.id == category.id }) && !category.events.contains(where: { $0.id == event.id })
            })
            
            guard !newEvents.isEmpty else { return category }
            
            var cat = category
            cat.events += newEvents
            
            return cat
        }).sorted(by: { $0.events.count > $1.events.count })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryRelay.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categoryRelay.value[indexPath.row]
        cell.textLabel?.text = "\(category.title) (\(category.events.count))"
        cell.detailTextLabel?.text = category.description
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = category.events.count > 0 ? .disclosureIndicator : .none
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEvents" {
            guard let eventTVC = segue.destination as? EventTableViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let category = categoryRelay.value[indexPath.row]
            
            eventTVC.eventRelay.accept(category.events)
            eventTVC.title = category.title
        }
    }
}
