import UIKit
import RxSwift

func skipCount() { // 해당 엘레먼트 갯수를 스킵하고 그 뒤부터 구독함
    let bag = DisposeBag()
    
    Observable.from(Array(1...10))
        .skip(7).subscribe( {print($0) }).disposed(by: bag)
    
    Observable.from(["NY","Seoul","Tokyo"]).skip(1).subscribe( {print($0)} ).disposed(by: bag)
}
skipCount()

print(" ================== ")

func skipWhile() { // 조건이 충족 될 때까지만 스킵하고, 조건이 깨지면 계속 구독한다
    let bag = DisposeBag()
    
    Observable.from([2, 3, 4, 6, 8, 9]).skipWhile( {$0 % 2 == 0} ).subscribe( {print($0)} ).disposed(by: bag)
}
skipWhile()

print(" ================== ")

func skipUntil() {
    let bag = DisposeBag()
    
    let subject = PublishSubject<Int>() // 구독하기 전까지는 신경쓰지 않음
//    let trigger = PublishSubject<String>()
    let trigger2 = PublishSubject<Void>()
    
    subject.skipUntil(trigger2).subscribe( {print($0)} ).disposed(by: bag)
    
    subject.onNext(1)
    subject.onNext(2)
//    trigger.onNext("NOW")
    trigger2.onNext(())
    subject.onNext(3)
    subject.onNext(4)
}
skipUntil()
