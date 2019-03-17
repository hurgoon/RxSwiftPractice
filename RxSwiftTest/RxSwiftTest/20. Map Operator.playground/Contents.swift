import UIKit
import RxSwift

func toArray() {
    let bag = DisposeBag()
    
    Observable.of(1, 2, 3, 4, 5).toArray().subscribe({ print($0) }).disposed(by: bag)
}
toArray()

print(" =================" )

func map() {
    var dates = [Date]()
    
    for day in 0...5 {
        guard let date = Calendar.current.date(byAdding: .day, value: day, to: Date()) else { return }
        dates.append(date)
    }
    
    let formatter = DateFormatter()
    
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    
    let bag = DisposeBag()
    
    Observable.from(dates).map({ formatter.string(from: $0 ) }).subscribe({ print($0) }).disposed(by: bag)
    // 모든 데이터를 스트링 포매터로 전환 시킴
}
map()

print(" =================" )

func enumerated() {
    let bag = DisposeBag()
    
    Observable.of("Apple", "Amazon", "Alphabet").enumerated().map({ "Rank \($0.index) = \($0.element)"}).subscribe({ print($0) }).disposed(by: bag)
    
}
enumerated()
