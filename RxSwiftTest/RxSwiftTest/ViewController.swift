//
//  ViewController.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 04/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    var shownCities = [String]()
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"] // 고정된 API 데이터
    let disposeBag = DisposeBag() // 뷰가 할당 해제될 때 놓아줄 수 있는 일회용 가방
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.dataSource = self
        
        searchBar
            .rx.text // RxCocoa의 Observable 속성
            .orEmpty // 옵셔널이 아니도록 함
            .debounce(0.5, scheduler: MainScheduler.instance) // wait o.5 for changes
            .distinctUntilChanged() // 새로운 값이 이전의 값과 같은지 확인함.
            .filter { !$0.isEmpty } // 새로운 값이 정말 새롭지 않다면, 비어있지 않은 쿼리를 위해 필터링
            .subscribe(onNext: { [unowned self] query in // 이 부분이 모든 새로운 값에 대한 알림을 받게 함
                self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // 도시를 찾기 위한 "API"요청 작업을 함
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        
        return cell
    }
}


