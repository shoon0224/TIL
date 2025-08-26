//
//  DetailWriteFormCellViewModel.swift
//  UsedGoodsUpload-MVVM
//
//  Created by 이상훈 on 8/26/25.
//

// Model을 먼저 만드는 것이 좋다
// 이벤트 흐름을 먼저 생각하고 전체적으로 이뷰가 어떤 액션을 취할 것인지
// ViewModel을 만들고 View를 만드는걸 습관화 하는게 좋다


import RxSwift
import RxCocoa

struct DetailWriteFormCellViewModel {
    //View -> ViewModel
    let contentValue = PublishRelay<String?>()
}

