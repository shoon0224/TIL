//
//  SearchBar.swift
//  SearchDaumBlog
//
//  Created by 이상훈 on 8/23/25.
//

import UIKit
import RxSwift
import RxCocoa

class SearchBar: UISearchBar {
    let disposeBag = DisposeBag()
    
    let searchButton = UIButton()
    
    //SearchBar 버튼 탭 이벤트
    let searchButtonTapped = PublishRelay<Void>()
    
    //SearchBar 외부로 내보낼 이벤트
    var shouldLoadResult = Observable<String>.of("")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        Observable
            .merge( ///merge : 여러 시퀀스를 하나로 섞어버리기
                self.rx.searchButtonClicked.asObservable(), /// 키보드에 있는 검색버튼 -> 여기는 UISearchBar를 상속하고 있어서 그럼
                searchButton.rx.tap.asObservable() /// 이건 우리가 검색 창 옆에 만들 커스텀 검색 버튼
                ///merge는 Observable() 타입만 취급함 그래서 뒤에 asObservable()을 붙인것
            )/// 그래서 둘중 뭘 선택하든 같은 이벤트를 받기 위함
            .bind(to: searchButtonTapped)
            .disposed(by: disposeBag)
        
        searchButtonTapped
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        
    }
    
    
}

extension Reactive where Base: SearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}
