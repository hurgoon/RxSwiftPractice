import UIKit
import RxSwift

func share() {
    var num = 0
    
    func getFirst() -> Int {
        num += 1
        
        return num
    }
    
    let observable = Observable<Int>.create { (observer) -> Disposable in
        let first = getFirst()
        
        observer.onNext(first)
        observer.onNext(first + 1)
        observer.onNext(first + 2)
//        observer.onCompleted()
        
        return Disposables.create {
            print("Disposed")
        }
    }.share(replay: 3, scope: .forever)
    
    let bag = DisposeBag()
    
    observable.subscribe({ print("first", $0) }).disposed(by: bag)
    observable.subscribe({ print("second", $0) }).disposed(by: bag)
    
}
share()
