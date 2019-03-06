import UIKit
import RxSwift

let justObservable = Observable.just(5) // "just"는 Int 하나만 가능
let doubleObservable: Observable<Double> = Observable<Double>.just(5)
let ofObservable = Observable.of(1)
let multiObservable = Observable.of(1, 2, 3, 4)
let arrayObservable = Observable.of([1, 2], [3, 4])
let fromObservable = Observable.from([1, 2, 3, 4])
