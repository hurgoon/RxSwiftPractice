import UIKit
import RxSwift

enum SomeError: Error {
    case unknown
}

func ignoreAllElements() {
    
    let bag = DisposeBag()
    let progress = PublishSubject<Float>() // 오픈한 선물에는 관심이 없고 나머지를 앉아서 기다리고 있음.
    
    progress.ignoreElements().subscribe({ print($0) }).disposed(by: bag) // ignore했기 때문에 구독 하지 않는다
    
    progress.onNext(0.2)
    progress.onNext(0.6)
    progress.onNext(0.9)
    
//    progress.onCompleted() // 컴플리트만 구독됨
    progress.onError(SomeError.unknown) // 에러 이벤트만 구독됨
}
ignoreAllElements()

print("======================= ")

// 로그인 시도 실패시 아이디 락거는 펑션
func loginAttemts() {
    let bag = DisposeBag()
    let login = PublishSubject<String>()
    
    login.elementAt(0).subscribe({ print($0) }).disposed(by: bag) // 해당 순번만 구독 나머지는 무시하고 completed 시킴
    
    login.onNext("One")
    login.onNext("Two")
    login.onNext("Three")
    login.onNext("Four")
}
loginAttemts()

print("======================= ")

// Ignore Element의 한 종류(필터링)
func sameFilter() {
    let bag = DisposeBag()
    let evenNum = PublishSubject<Int>()
    
    evenNum.filter({ $0 % 2 == 0 }).subscribe({ print($0) }).disposed(by: bag)
    
    for num in 0...10 {
        evenNum.onNext(num)
    }
}
sameFilter()
