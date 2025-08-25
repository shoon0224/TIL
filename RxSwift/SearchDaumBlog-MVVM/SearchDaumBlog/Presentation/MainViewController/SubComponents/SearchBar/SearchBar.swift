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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: SearchBarViewModel) {
        self.rx.text
            .bind(to: viewModel.queryText)
            .disposed(by: disposeBag)
        
        Observable
            .merge( ///merge : 여러 시퀀스를 하나로 섞어버리기
                self.rx.searchButtonClicked.asObservable(), /// 키보드에 있는 검색버튼 -> 여기는 UISearchBar를 상속하고 있어서 그럼
                searchButton.rx.tap.asObservable() /// 이건 우리가 검색 창 옆에 만들 커스텀 검색 버튼
                ///merge는 Observable() 타입만 취급함 그래서 뒤에 asObservable()을 붙인것
            )/// 그래서 둘중 뭘 선택하든 같은 이벤트를 받기 위함
            .bind(to: viewModel.searchButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.searchButtonTapped
            .asSignal() ///Relay를 Signal로 변환, 이제 UI 이벤트 스트림이라는 의미
            .emit(to: self.rx.endEditing) ///emit은 Signal 전용 바인딩 메서드 (RxCocoa)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    private func layout() {
        addSubview(searchButton)
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
    
}

extension Reactive where Base: SearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}
