import UIKit
import RxSwift
import RxCocoa

func reduce() { // 결과만 방출
    let bag = DisposeBag()
    
//    Observable.from(Array(1...5)).reduce(0, accumulator: +).subscribe({ print($0) }).disposed(by: bag)
    
//    Observable.from(Array(1...5)).reduce(0) { (summery, next) -> Int in
//        return summery + next
//    }.subscribe({ print($0) }).disposed(by: bag)
    
    let relay = PublishRelay<Int>() // Publish Relay는 종결되지 않는다
    relay.reduce(0, accumulator: +).subscribe({ print($0) }).disposed(by: bag)
    
    for num in 1...5 {
        relay.accept(num)
    }
    
//     relay.onCompleted() // 그렇다고 relay는 onCompleted를 받지도 않는다
}
reduce()

print("=============")

let summery = Array(1...5).reduce(0, +)
print(summery)

print("=============")

func scan() { // 단계별로 방출
    let bag = DisposeBag()
    
//    Observable.from(Array(1...5)).scan(0, accumulator: +).subscribe({ print($0) }).disposed(by: bag)
    
    let relay = PublishRelay<Int>()
    
    relay.scan(0, accumulator: +).subscribe({ print($0) }).disposed(by: bag) // 컴플리트는 되지 않는가...

    for num in 1...5 {
        relay.accept(num)
    }
}
scan()
