//
//  OpenWeatherMapViewController.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 07/04/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OpenWeatherMapViewController: UIViewController {

    // Outlets
    @IBOutlet weak var searchCityTxtFld: UITextField!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    
    // Variables
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchCityTxtFld.rx.text
            .throttle(1, scheduler: MainScheduler.instance) // 1초 인터벌을 두고 실행(같이 써도되고 트로틀만 써도 된다)
            .filter { !($0 ?? "").isEmpty } // nil value 제거
            .map({ $0 ?? "Error" }) // optional 제거
            .flatMapLatest { (name) -> Observable<Weather> in // 그냥 flatMap을 쓰면 글자 바뀔때 마다 네트워킹
                return ApiNetworking.shared.currentWeather(for: name)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (weather) in
                self.tempLbl.text = "\(weather.main.temp)℃"
                self.humidityLbl.text = "湿度 ： \(weather.main.humidity)%"
                self.cityLbl.text = "\(weather.name), \(weather.sys.country)"
            })
            .disposed(by: bag)
    }
}
