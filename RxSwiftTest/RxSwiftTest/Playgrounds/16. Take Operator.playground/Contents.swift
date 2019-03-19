import UIKit
import RxSwift

func takeCount() { // take() 번째까지 구독, 나머지는 버림
    let bag = DisposeBag()
    
    Observable.from(Array(1...10)).take(4).subscribe({ print($0) }).disposed(by: bag)
    
}
takeCount()

print("=======================")

func takeWhile() { // 조건이 만족할 때까지만 구독하고, 조건에서 벗어나면 구독하지 않는다
    let bag = DisposeBag()
    
    Observable.from([2, 4, 6, 7, 8, 9]).takeWhile({ $0 % 2 == 0 }).subscribe({ print($0) }).disposed(by: bag)
    
}
takeWhile()

print("=======================")

func takeUntil() {
    let bag = DisposeBag()
    
    let subject = PublishSubject<Int>()
    let trigger = PublishSubject<Void>()
    
    subject.takeUntil(trigger).subscribe({ print($0) }).disposed(by: bag)
    
    subject.onNext(1)
    subject.onNext(2)
    trigger.onNext(())
    subject.onNext(3)
    subject.onNext(4)
}
takeUntil()
