import UIKit
import RxSwift

func zip() {
    enum Weather {
        case sunny, cloudy
    }
    
    enum WError: Error { case unknown }
    
    let first = Observable<Weather>.of(.sunny, .cloudy, .sunny)
//    let second = Observable.of("LA", "SF", "NY", "Boston")
    
    let second = Observable<String>.create { (observer) -> Disposable in
        observer.onNext("LA")
        observer.onNext("SF")
        observer.onNext("NY")
        observer.onNext("BT")
//        observer.onError(WError.unknown) // 에러끼면 전부 실행 안됨
        
        return Disposables.create()
    }
    
    let bag = DisposeBag()
    
    Observable.zip(first, second) { (weather, city) -> String in   // 하나씩 매칭됨.
        return "It's \(weather) day in \(city)"
        }.subscribe({ print($0) }).disposed(by: bag)
}
zip()

print(" +++++++++++++ ")

let first = Array(1...5)
let second = Array(6...11)
let tuples = Array(zip(first, second))
print(tuples)

for (num1, num2) in tuples {
    print(num1, num2)
}
