//
//  RxTableViewTestController.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 08/04/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxTableViewTestController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let bag = DisposeBag()
    let observable = Observable.just(Array(1...9))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        observable.bind(to: tableView.rx.items) { (tableView, row, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.text = String(element)
            return cell
        }.disposed(by: bag)
        
    }
    
}
