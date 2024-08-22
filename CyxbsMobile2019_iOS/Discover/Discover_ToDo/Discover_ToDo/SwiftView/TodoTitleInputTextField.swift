//
//  TodoTitleInputTextField.swift
//  CyxbsMobile2019_iOS
//
//  Created by Max Xu on 2024/8/20.
//  Copyright © 2024 Redrock. All rights reserved.
//

import UIKit

class TodoTitleInputTextField: UITextField {

    private let offset: CGFloat = 0.04533333333 * UIScreen.main.bounds.width

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        self.layer.cornerRadius = 22
        self.backgroundColor = UIColor.ry(light: "#E8F1FC", dark: "#1F1F1F")
        self.textColor = UIColor.ry(light: "#15315B", dark: "#F0F0F2")
        self.font = UIFont(name: "PingFangSC-Medium", size: 15)
        self.placeholder = "添加代办事项"
    }

    /// 重写后可以改变非编辑状态时光标的位置
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: offset, dy: 0)
    }

    /// 重写后可以改变编辑时光标的位置
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: offset, dy: 0)
    }
}

