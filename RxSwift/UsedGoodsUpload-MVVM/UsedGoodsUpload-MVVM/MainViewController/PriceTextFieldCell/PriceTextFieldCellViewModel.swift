//
//  PriceTextFieldCellViewModel.swift
//  UsedGoodsUpload-MVVM
//
//  Created by 이상훈 on 8/26/25.
//

import RxSwift
import RxCocoa

struct PriceTextFieldCellViewModel {
    let disposeBag = DisposeBag()
    
    //ViewModel -> View
    let showFreeShareButton: Signal<Bool>
    let resetPrice: Signal<Void>
    
    //View -> ViewModel
    let priceValue = PublishRelay<String?>()
    let freeShareButtonTapped = PublishRelay<Void>()
    
    init() {
        self.showFreeShareButton = Observable
            .merge(
                priceValue.map { $0 ?? "" == "0"}, //priceValue가 빈값이거나 0으로 입력이면 무료나눔 이란 뜻
                freeShareButtonTapped.map { _ in false} // 눌렸을 때는 더 이상 버튼을 보여주면 안됨
            )
            .asSignal(onErrorJustReturn: false) //에러나면 숨기기
        
        self.resetPrice = freeShareButtonTapped //무료나눔 버튼이 선택되면 비워라
            .asSignal(onErrorSignalWith: .empty())
    }
}
