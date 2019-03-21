import UIKit
import RxSwift

func startWith()  { // 시작시 디폴트 값 설정
    let bag = DisposeBag()
    
    Observable.from(Array(1...5)).startWith(0).subscribe({ print($0) }).disposed(by: bag)
    
}
startWith()

print(" ========== ")

enum NumError: Error {
    case unknown
}

func concat() { // 합체!!!
    let bag = DisposeBag()
    
    let first = Observable.from(Array(1...3))
//    let second = Observable.from(Array(4...6))
    
    let second = Observable<Int>.create { (observer) -> Disposable in
        observer.onNext(4)
        observer.onError(NumError.unknown)
        return Disposables.create()
    }
    
//    let second = Observable.just("fail") // concat을 쓰기 위해서는 타입이 같아야 한다.
    let third = Observable.from(Array(7...9))
    
//    Observable.concat(first, second, third).subscribe({ print($0) }).disposed(by: bag) // 하기와 동일
    first.concat(second).concat(third).subscribe({ print($0) }).disposed(by: bag)
}
concat()

print(" ========== ")

func concatMap() { // 두개 이상의 오브저버블을 하나로 이어줌
    let bag = DisposeBag()
    
    let dict = ["first": Observable.from(Array(1...3)), "second": Observable.from(Array(4...6))]
    Observable.of("first", "second").concatMap { (key) -> Observable<Int> in
        return dict[key] ?? .empty()
        }.subscribe({ print($0) }).disposed(by: bag)
}
concatMap()
