//
//  EventTableViewController.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 01/04/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EventTableViewController: UITableViewController {

    let eventRelay = BehaviorRelay<[EOEvent]>(value: [])
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        eventRelay.subscribe(onNext: { [weak self] (_) in
            self?.tableView.reloadData()
        }).disposed(by: bag)
       
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventRelay.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        cell.textLabel?.text = eventRelay.value[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
}
