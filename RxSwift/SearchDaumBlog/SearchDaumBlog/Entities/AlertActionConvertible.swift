//
//  AlertActionConvertible.swift
//  SearchDaumBlog
//
//  Created by 이상훈 on 8/24/25.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
