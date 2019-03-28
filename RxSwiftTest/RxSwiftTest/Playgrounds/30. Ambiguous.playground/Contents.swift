import UIKit
import RxSwift

func ambiguous() {
    let bag = DisposeBag()
    let odd = PublishSubject<Int>()
    let even = PublishSubject<Int>()
    
    let observable = odd.amb(even) // 2개의 서브젝트가 한 옵저버블에 컴바인 -> 싱글 옵저버블로 리턴
    // 처음에 시작된 하나만 방출... 어따쓰지..?
    
    observable.subscribe({ print($0) }).disposed(by: bag)
    
    odd.onNext(1)
    odd.onNext(0)
    even.onNext(2)
    odd.onNext(3)
    even.onNext(4)
    odd.onNext(5)
}
ambiguous()

print(" =========== ")

func switchLatest() {
    let bag = DisposeBag()
    let first = PublishSubject<Int>()
    let second = PublishSubject<Int>()
    let third = PublishSubject<Int>()
    let subject = PublishSubject<Observable<Int>>()
    
    subject.switchLatest().subscribe({ print($0) }).disposed(by: bag)
    
    subject.onNext(first)
    first.onNext(1)
    first.onNext(2)
    subject.onNext(second) // 서브젝트가 스위치되면 스위치 된것 부터 방출한다
    first.onNext(3)
    second.onNext(4)
    second.onNext(5)
    subject.onNext(third)
    first.onNext(6)
    second.onNext(7)
    third.onNext(8)
    third.onNext(9)
}
switchLatest()
