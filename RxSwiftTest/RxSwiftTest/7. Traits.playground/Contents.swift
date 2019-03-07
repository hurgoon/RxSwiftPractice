/*
 
 Traits
 
 1. Singles
 - Success with value followed by Completed
 - Error
 
 2. Completable
 - Completed
 - Error
 
 3. Maybe
 - Success with value
 - Completed
 - Error
 
 */

import UIKit
import RxSwift

enum FileError: Error {
    case fileNotFound, unreadable, encodingFailed
}

func loadFile(from fileName: String) -> Single<String> {
    return Single.create(subscribe: { (single) -> Disposable in
        
        let disposable = Disposables.create()
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else {
            single(.error(FileError.fileNotFound))
            return disposable }
        
        guard let data = FileManager.default.contents(atPath: path) else {
            single(.error(FileError.unreadable))
            return disposable
        }
        
        if let quote = String(data: data, encoding: .utf8) {
            single(.success(quote))
        } else {
            single(.error(FileError.encodingFailed))
        }
        
        return disposable
    })
}

func singles() {
    let single = loadFile(from: "quote")
    let bag = DisposeBag()
    
//    single.subscribe { (event) in
//
//        switch event {
//            case .error(let error): print(error)
//            case .success(let quote): print(quote)
//        }
//    }.disposed(by: bag)
    
    // 상기의 간략화
    single.subscribe(onSuccess: { print($0) }, onError: { print($0) }).disposed(by: bag)
}

singles()


/*
 <概要>
 まず前提として、 Observable は Completed あるいは Error が流れた時点でそれ以上何も流れなくなりますが、その2つが流れない限り Next は延々と流れてくる可能性があります。
 
 それを踏まえて今回追加された3つのUnitについて見てみると、以下の表のようになります。
 
            Single    Maybe    Completable
    Success    ○        ○          ×
    Completed  ×        ○          ○
    Error      ○        ○          ○
 
 Success は 1回だけ流れる Next だと思って下さい。
 そのSuccess が流れるのが Single と Maybe です。
 Maybe は Success が流れず、 Completed のみ流れてくる可能性があります。
 Completable では Success は流れてきません。
 
 <所感>
 今回追加されたUnitは使いたいシーンが結構ありそうです。
 今まで Next が何回流れるか示したい場合はAppleDoc等で分かるようにしないといけませんでした。1回だけで良いのであれば、 Single や Maybe を使えば、ドキュメントに記載しなくても意図が明確になります。
 
 */

