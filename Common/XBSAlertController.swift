//
//  XBSAlertController.swift
//  CyxbsMobile2019_iOS
//
//  Created by Max Xu on 2024/9/29.
//  Copyright © 2024 Redrock. All rights reserved.
//  掌邮风格的AlertController

import UIKit

class XBSAlertController: UIViewController {

    // MARK: - Properties
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ry(light: "#FFFFFF", dark: "#2C2C2C")
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ry(light: "#15315B", dark: "#F0F0F2")
        label.textAlignment = .center
        return label
    }()
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ry(light: "#15315B", dark: "#F0F0F2")
        label.textAlignment = .center
        return label
    }()
    private let cancelButton: UIButton = {
        // Configure buttons
        let button = UIButton()
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.backgroundColor = .ry(light: "#C3D4EE", dark: "#515151")
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        return button
    }()
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.backgroundColor = .ry(light: "#C3D4EE", dark: "#5852FF")
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        return button
    }()
    
    private var confirmAction: (() -> Void)?
    private var cancelAction: (() -> Void)?

    // MARK: - Life Cycle
    init(title: String?, titleFont: UIFont = .systemFont(ofSize: 15), message: String?, messageFont: UIFont = .systemFont(ofSize: 15), titleOfConfirmButton: String = "确定", confirmAction: (() -> Void)?, titleOfCancelButton: String = "取消", cancelAction: (() -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
        
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(backgroundView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(messageLabel)
        backgroundView.addSubview(cancelButton)
        backgroundView.addSubview(confirmButton)
        
        titleLabel.text = title
        titleLabel.font = titleFont
        messageLabel.text = message
        messageLabel.font = messageFont
        cancelButton.setTitle(titleOfCancelButton, for: .normal)
        confirmButton.setTitle(titleOfConfirmButton, for: .normal)
        setupConstraints()
        
        let maskTapGes = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(maskTapGes)
        let backgroundTapGes = UITapGestureRecognizer()
        backgroundView.addGestureRecognizer(backgroundTapGes)
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addBtnGradient(button: confirmButton)
    }
    
    private func setupConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Background view constraints
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: 303),
            backgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 171),

            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 31),
            titleLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -16),

            // Message label constraints
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            messageLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 16),
            messageLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -16),

            // Button constraints
            cancelButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 26.5),
            cancelButton.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 49.5),
            cancelButton.widthAnchor.constraint(equalToConstant: 92),
            cancelButton.heightAnchor.constraint(equalToConstant: 36),

            confirmButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 26.5),
            confirmButton.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -49.5),
            confirmButton.widthAnchor.constraint(equalToConstant: 92),
            confirmButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    // MARK: - Methods
    // 给按钮添加渐变
    private func addBtnGradient(button: UIButton) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.init(hexString: "#4741E0").cgColor,
            UIColor.init(hexString: "#5D5EF7").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = button.bounds
        button.layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: - Button Actions
    @objc private func handleConfirm() {
        confirmAction?()
        dismiss(animated: true, completion: nil)
    }

    @objc private func handleCancel() {
        cancelAction?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapView(_ tapGes: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
