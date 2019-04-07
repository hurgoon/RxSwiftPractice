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

        // 41. Textfield in RxCocoa
//        searchCityTxtFld.rx.text
//            .throttle(1, scheduler: MainScheduler.instance) // 1초 인터벌을 두고 실행(같이 써도되고 트로틀만 써도 된다)
//            .filter { !($0 ?? "").isEmpty } // nil value 제거
//            .map({ $0 ?? "Error" }) // optional 제거
//            .flatMapLatest { (name) -> Observable<Weather> in // 그냥 flatMap을 쓰면 글자 바뀔때 마다 네트워킹
//                return ApiNetworking.shared.currentWeather(for: name)
//            }
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { (weather) in
//                self.tempLbl.text = "\(weather.main.temp)℃"
//                self.humidityLbl.text = "湿度 ： \(weather.main.humidity)%"
//                self.cityLbl.text = "\(weather.name), \(weather.sys.country)"
//            })
//            .disposed(by: bag)
        
        
        // 42. Label and TableView
//        let search = searchCityTxtFld.rx.text
//            .throttle(1, scheduler: MainScheduler.instance)
//            .filter{ !($0 ?? "").isEmpty }
//            .map( { $0 ?? "Error" })
//            .flatMapLatest { (name) -> Observable<Weather> in
//                return ApiNetworking.shared.currentWeather(for: name)
//            }
//            .share(replay: 1, scope: .whileConnected)
//            .observeOn(MainScheduler.instance)
//
//        search.map({ "\($0.main.temp)도씨" })
//            .bind(to: tempLbl.rx.text)
//            .disposed(by: bag)
//
//        search.map({ "습도 : \($0.main.humidity)"})
//            .bind(to: humidityLbl.rx.text)
//            .disposed(by: bag)
//
//        search.map({ "\($0.name), \($0.sys.country)"})
//            .bind(to: cityLbl.rx.text)
//            .disposed(by: bag)
        
        // 43. Traits in RxCocoa (driver)
//        let search = searchCityTxtFld.rx.text
//            .throttle(1, scheduler: MainScheduler.instance)
//            .filter{ !($0 ?? "").isEmpty }
//            .map( { $0 ?? "Error" })
//            .flatMapLatest { (name) -> Observable<Weather> in
//                return ApiNetworking.shared.currentWeather(for: name)
//            }
//            .asDriver(onErrorJustReturn: Weather.empty)
//
//        search.map({ "\($0.main.temp)도씨" })
//            .drive(tempLbl.rx.text)
//            .disposed(by: bag)
//
//        search.map({ "습도 : \($0.main.humidity)%"})
//            .drive(humidityLbl.rx.text)
//            .disposed(by: bag)
//
//        search.map({ "\($0.name), \($0.sys.country)"})
//            .drive(cityLbl.rx.text)
//            .disposed(by: bag)
        
        // 43. Traits in RxCocoa (controlEvent) 서치 버튼 눌렀을 때만 네트워킹
        let search = searchCityTxtFld.rx
            .controlEvent(.editingDidEndOnExit)
            .map({ self.searchCityTxtFld.text })
            .filter{ !($0 ?? "").isEmpty }
            .map( { $0 ?? "Error" })
            .flatMap { (name) -> Observable<Weather> in // 어차피 서치 버튼에서만 작동하기 때문에 flatMapLatest는 무용
                return ApiNetworking.shared.currentWeather(for: name)
            } 
            .asDriver(onErrorJustReturn: Weather.empty)
        
        search.map({ "\($0.main.temp)도씨" })
            .drive(tempLbl.rx.text)
            .disposed(by: bag)
        
        search.map({ "습도 : \($0.main.humidity)%"})
            .drive(humidityLbl.rx.text)
            .disposed(by: bag)
        
        search.map({ "\($0.name), \($0.sys.country)"})
            .drive(cityLbl.rx.text)
            .disposed(by: bag)
    }
}
