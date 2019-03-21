import UIKit
import RxSwift

enum NumError: Error { case unknown }

func merge() { // concat은 하나가 종료되야 다음이 시작되나, merge는 onNext들어오는 순서로 방출
    let bag = DisposeBag()
    let first = PublishSubject<Int>()
    let second = PublishSubject<Int>()
    let observable = Observable.of(first, second)
    
//    let merge = observable.merge()
    let merge = observable.merge(maxConcurrent: 1) // 공존하는 오브절버블 갯수 지정
    
    merge.subscribe({ print($0) }).disposed(by: bag)
    
    second.onNext(1)
    first.onNext(2)
//    first.onCompleted() // 컴플리트 되면 그 뒤의 first는 방출되지 않는다
//    first.onError(NumError.unknown) // 에러 발생하면 first는 물론이고 second도 방출되지 않는다
    first.onNext(3)
    second.onNext(4)
}
merge()
