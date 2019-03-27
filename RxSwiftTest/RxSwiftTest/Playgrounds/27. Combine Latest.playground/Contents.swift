import UIKit
import RxSwift

enum NumError: Error { case unknown}

func combineLatest() {
    let first = PublishSubject<Int>()
    let second = PublishSubject<Float>()
    let bag = DisposeBag()
    
//    Observable.combineLatest(first, second) { (firstLatest, secondLatest) -> String in
//        return "\(firstLatest), \(secondLatest)"
//        }.startWith("Started")
//        .subscribe({ print($0) })
//        .disposed(by: bag)
    
    Observable
        .combineLatest(first, second, resultSelector: {($0, $1) }) // first와 second를 받아서 resultSelector로 튜플을 만듬
        .filter({ $0.0 == 1 }) // 튜플의 첫번째 엘레멘트가 1 인것만 필터링
        .subscribe({ print($0) })
        .disposed(by: bag) // 세컨드는 바껴도 구독을 안하네...
    
    second.onNext(0.1) // 한가지 조건 만이면 구독하지 않음.
    first.onNext(1)    // 두가지 조건이 채워지면 구독.
    
//    first.onCompleted()
//    second.onCompleted()
//
//    first.onError(NumError.unknown) // 에러가 들아가면 그 전까지만 구독
    
    first.onNext(2)    // 서브젝트가 바뀌면 역시 구독
    second.onNext(0.5)
}
combineLatest()

print(" ================= ")

func dateFormatter() { // 오오 개쇼크!!
    let setting = Observable<DateFormatter.Style>.of(.short, .medium, .full)
    let dates = Observable.just(Date())
    let bag = DisposeBag()
    
    Observable.combineLatest(setting, dates) { (style, date) -> String in
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: date)
    }.subscribe({ print($0) }).disposed(by: bag)
}
dateFormatter()

print(" ================= ")

func collection() {
    let first = PublishSubject<Int>()
    let second = PublishSubject<Int>()
    let bag = DisposeBag()
    
    Observable.combineLatest([first, second]) { (latest) -> String in
        return "Total amt is $\(latest.reduce(0, +))"
        }.subscribe({ print($0) }).disposed(by: bag)
    
    second.onNext(1)
    first.onNext(2)
    first.onNext(3)
    second.onNext(5)
}
collection()
