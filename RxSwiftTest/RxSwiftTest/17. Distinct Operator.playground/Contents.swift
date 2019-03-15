import UIKit
import RxSwift

func distinctInARow() { // 변화 있을 때만 섭스크라이브
    let bag = DisposeBag()
    
    Observable.from([0,0,1,1,1,2,3,3,3,3,1]).distinctUntilChanged().subscribe({ print($0) }).disposed(by: bag)

}
distinctInARow()

print(" ============== ")

func customDistict() { // 조건이 true 일때는 스킵, false일때는 구독한다
    let bag = DisposeBag()
    
    Observable.from([0,1,0,2,1,0,3,2,0,4]).distinctUntilChanged { (first, second) -> Bool in
        print("first ", "=",first )
        print("second ", "=",second )
        print("first > second ", "=",first > second )
        return first > second
        }.subscribe( {print($0) }).disposed(by: bag)
}
customDistict()
