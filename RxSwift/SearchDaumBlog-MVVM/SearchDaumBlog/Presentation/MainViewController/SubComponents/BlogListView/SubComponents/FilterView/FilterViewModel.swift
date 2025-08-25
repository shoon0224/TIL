//
//  FilterViewModel.swift
//  SearchDaumBlog
//
//  Created by 이상훈 on 8/25/25.
//

import RxSwift
import RxCocoa

struct FilterViewModel {
    /// FilterView에서는 아래와 같은 버튼 이벤트를 방출하는 구나를 알 수 있음
    let sortButtonTapped = PublishSubject<Void>()
}
