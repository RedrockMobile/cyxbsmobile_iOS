//
//  ToDoAlertView.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2024/8/23.
//  Copyright © 2024 Redrock. All rights reserved.
//

import UIKit

protocol ToDoAlertViewDelegate: AnyObject {
    func confirmDecision()
    func cancelDecision()
}

// todo提示框视图
class ToDoAlertView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ToDoAlertViewDelegate?

    // MARK: - Life Cycle
    
    init(firstLineStr: String, secondLineStr: String) {
        super.init(frame: .zero)
        firstLineLab.text = firstLineStr
        secondLineLab.text = secondLineStr
        addSubview(backgroundView)
        backgroundView.addSubview(firstLineLab)
        backgroundView.addSubview(secondLineLab)
        backgroundView.addSubview(cancelBtn)
        backgroundView.addSubview(confirmBtn)
        self.backgroundColor = UIColor(.dm, light: UIColor(hexString: "#000000", alpha: 0.47), dark: UIColor(hexString: "#000000", alpha: 0.5))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = CGRect(x: (SCREEN_WIDTH - 303) / 2, y: 272, width: 303, height: 171)
        firstLineLab.frame = CGRect(x: 0, y: 31, width: backgroundView.width, height: 21)
        secondLineLab.frame = CGRect(x: firstLineLab.left, y: firstLineLab.bottom, width: firstLineLab.width, height: firstLineLab.height)
        cancelBtn.frame = CGRect(x: 49.5, y: secondLineLab.bottom + 26.5, width: 92, height: 36)
        confirmBtn.frame = CGRect(x: cancelBtn.right + 20, y: cancelBtn.top, width: cancelBtn.width, height: cancelBtn.height)
        addBtnGradient(button: confirmBtn)
    }
    
    // MARK: - Method
    
    // 给按钮添加渐变
    private func addBtnGradient(button: UIButton) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hexString: "#4741E0", alpha: 1).cgColor,
            UIColor(hexString: "#5D5EF7", alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = button.bounds
        button.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc private func clickCancelBtn() {
        delegate?.cancelDecision()
    }
    
    @objc private func clickConfirmBtn() {
        delegate?.confirmDecision()
    }
    
    // MARK: - Lazy
    
    /// 弹窗的容器视图
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 12
        backgroundView.clipsToBounds = true
        backgroundView.backgroundColor = UIColor(.dm, light: UIColor(hexString: "#FFFFFF", alpha: 1), dark: UIColor(hexString: "#2C2C2C", alpha: 1))
        return backgroundView
    }()
    /// 第一行的文本
    private lazy var firstLineLab: UILabel = {
        let firstLineLab = UILabel()
        firstLineLab.textAlignment = .center
        firstLineLab.font = .systemFont(ofSize: 15)
        firstLineLab.textColor = UIColor(.dm, light: UIColor(hexString: "#15315B", alpha: 1), dark: UIColor(hexString: "#F0F0F2", alpha: 1))
        return firstLineLab
    }()
    /// 第二行的文本
    private lazy var secondLineLab: UILabel = {
        let secondLineLab = UILabel()
        secondLineLab.textAlignment = .center
        secondLineLab.font = .systemFont(ofSize: 15)
        secondLineLab.textColor = UIColor(.dm, light: UIColor(hexString: "#15315B", alpha: 1), dark: UIColor(hexString: "#F0F0F2", alpha: 1))
        return secondLineLab
    }()
    /// 取消按钮
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton()
        cancelBtn.layer.cornerRadius = 18
        cancelBtn.clipsToBounds = true
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        cancelBtn.backgroundColor = UIColor(.dm, light: UIColor(hexString: "#C3D4EE", alpha: 1), dark: UIColor(hexString: "#515151", alpha: 1))
        cancelBtn.addTarget(self, action: #selector(clickCancelBtn), for: .touchUpInside)
        return cancelBtn
    }()
    /// 确定按钮
    lazy var confirmBtn: UIButton = {
        let confirmBtn = UIButton()
        confirmBtn.layer.cornerRadius = 18
        confirmBtn.clipsToBounds = true
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        confirmBtn.backgroundColor = UIColor(.dm, light: UIColor(hexString: "#C3D4EE", alpha: 1), dark: UIColor(hexString: "#5852FF", alpha: 1))
        confirmBtn.addTarget(self, action: #selector(clickConfirmBtn), for: .touchUpInside)
        return confirmBtn
    }()
}
