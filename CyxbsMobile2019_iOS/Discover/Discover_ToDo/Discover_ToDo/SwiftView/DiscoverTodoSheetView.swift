//
//  DiscoverTodoSheetView.swift
//  CyxbsMobile2019_iOS
//
//  Created by Max Xu on 2024/8/20.
//  Copyright © 2024 Redrock. All rights reserved.
//

import UIKit

protocol DiscoverTodoSheetViewDelegate: AnyObject {
    func sheetViewSaveBtnClicked(_ dataModel: TodoDataModel)
    func sheetViewCancelBtnClicked()
}

class DiscoverTodoSheetView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    
    weak var delegate: DiscoverTodoSheetViewDelegate?
    
    private let backView = UIView()
    private let cancelBtn = UIButton()
    private let saveBtn = UIButton()
    private let remindTimeBtn = UIButton()
    private let repeatModelBtn = UIButton()
    private let titleInputTextField = TodoTitleInputTextField()
    private let deleteBtn = UIButton()
    
    private lazy var selectTimeView: DiscoverTodoSelectTimeView = {
        let view = DiscoverTodoSelectTimeView()
        backView.addSubview(view)
        view.delegate = self
        view.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.4729064039 * SCREEN_HEIGHT)
        }
        return view
    }()
    
    private lazy var selectRepeatView: DiscoverTodoSelectRepeatView = {
        let view = DiscoverTodoSelectRepeatView()
        backView.addSubview(view)
        view.delegate = self
        view.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.4729064039 * SCREEN_HEIGHT)
        }
        return view
    }()
    
    private var dataModel = TodoDataModel()

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(cancel))
        self.addGestureRecognizer(tapGes)
        self.backgroundColor = .clear
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        self.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 1.7389162562 * SCREEN_HEIGHT))
        }
        self.addSubview(backView)
        backView.backgroundColor = UIColor.ry(light: "#FFFFFF", dark: "#2C2C2C")
        backView.layer.mask = createRoundedCornerMask()
        let tapGes = UITapGestureRecognizer()
        backView.addGestureRecognizer(tapGes)
        backView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(UIScreen.main.bounds.height * 0.7389)
        }
        
        setupCancelButton()
        setupSaveButton()
        setupTitleInputTextField()
        setupRemindTimeButton()
        setupDeleteButton()
        setupRepeatModelButton()
    }
    
    private func createRoundedCornerMask() -> CAShapeLayer {
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7389)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 16, height: 16))
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        return layer
    }
    
    private func setupCancelButton() {
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.ry(light: "#15315B", dark: "#F0F0F2"), for: .normal)
        cancelBtn.titleLabel?.font = UIFont(name: PingFangSCSemibold, size: 15)
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        backView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.left.equalTo(backView).offset(UIScreen.main.bounds.width * 0.04)
            make.top.equalTo(backView).offset(UIScreen.main.bounds.width * 0.02586)
        }
    }
    
    private func setupSaveButton() {
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.setTitleColor(UIColor.ry(light: "#15315B", dark: "#F0F0F2"), for: .normal)
        saveBtn.alpha = 0.4
        saveBtn.titleLabel?.font = UIFont(name: PingFangSCSemibold, size: 15)
        saveBtn.addTarget(self, action: #selector(saveBtnClicked), for: .touchUpInside)
        
        backView.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { make in
            make.right.equalTo(backView).offset(-UIScreen.main.bounds.width * 0.04)
            make.top.equalTo(backView).offset(UIScreen.main.bounds.width * 0.02586)
        }
    }
    
    private func setupTitleInputTextField() {
        titleInputTextField.delegate = self
        
        backView.addSubview(titleInputTextField)
        titleInputTextField.snp.makeConstraints { make in
            make.left.equalTo(backView).offset(UIScreen.main.bounds.width * 0.048)
            make.top.equalTo(backView).offset(UIScreen.main.bounds.height * 0.09236)
            make.width.equalTo(UIScreen.main.bounds.width * 0.904)
            make.height.equalTo(UIScreen.main.bounds.width * 0.11733)
        }
    }
    
    private func setupRemindTimeButton() {
        setupStandardButton(remindTimeBtn, title: "设置提醒时间", imageName: "todo提醒的小铃铛")
        remindTimeBtn.addTarget(self, action: #selector(remindTimeBtnClicked), for: .touchUpInside)
        
        backView.addSubview(remindTimeBtn)
        remindTimeBtn.snp.makeConstraints { make in
            make.left.equalTo(backView).offset(UIScreen.main.bounds.width * 0.048)
            make.top.equalTo(backView).offset(UIScreen.main.bounds.height * 0.17611)
        }
        
        remindTimeBtn.imageView?.snp.makeConstraints { make in
            make.left.equalTo(remindTimeBtn)
            make.centerY.equalTo(remindTimeBtn.titleLabel!)
            make.right.equalTo(remindTimeBtn.titleLabel!.snp.left).offset(-UIScreen.main.bounds.width * 0.032)
            make.width.equalTo(UIScreen.main.bounds.width * 0.05333)
            make.height.equalTo(UIScreen.main.bounds.width * 0.056)
        }
    }
    
    private func setupRepeatModelButton() {
        setupStandardButton(repeatModelBtn, title: "设置重复提醒", imageName: "todo的小闹钟")
        repeatModelBtn.addTarget(self, action: #selector(repeatModelBtnClicked), for: .touchUpInside)
        
        backView.addSubview(repeatModelBtn)
        repeatModelBtn.snp.makeConstraints { make in
            make.left.equalTo(backView).offset(UIScreen.main.bounds.width * 0.048)
            make.top.equalTo(backView).offset(UIScreen.main.bounds.height * 0.22167)
        }
        
        repeatModelBtn.imageView?.snp.makeConstraints { make in
            make.left.equalTo(repeatModelBtn)
            make.centerY.equalTo(repeatModelBtn.titleLabel!)
            make.right.equalTo(repeatModelBtn.titleLabel!.snp.left).offset(-UIScreen.main.bounds.width * 0.032)
            make.width.equalTo(UIScreen.main.bounds.width * 0.05333)
            make.height.equalTo(UIScreen.main.bounds.width * 0.05778)
        }
    }
    
    private func setupDeleteButton() {
        deleteBtn.setTitle("删除", for: .normal)
        deleteBtn.setTitleColor(UIColor.ry(light: "#7BA2E9", dark: "#838385"), for: .normal)
        deleteBtn.titleLabel?.font = UIFont(name: PingFangSCMedium, size: 15)
        deleteBtn.alpha = 0
        deleteBtn.addTarget(self, action: #selector(deleteBtnClicked), for: .touchUpInside)
        
        addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.centerY.equalTo(remindTimeBtn)
            make.right.equalTo(self).offset(-UIScreen.main.bounds.width * 0.04)
        }
    }
    
    private func setupStandardButton(_ button: UIButton, title: String, imageName: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.ry(light: "#14305B", dark: "#EFEFF1"), for: .normal)
        button.setTitleColor(UIColor.ry(light: "#14305B", dark: "#EFEFF1"), for: .highlighted)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.titleLabel?.font = UIFont(name: PingFangSCMedium, size: 15)
    }

    // MARK: - Actions
    
    @objc private func cancel() {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = .identity
            self.backgroundColor = .clear
        }) { _ in
            self.removeFromSuperview()
        }
        delegate?.sheetViewCancelBtnClicked()
    }
    
    @objc private func saveBtnClicked() {
        guard let title = titleInputTextField.text, !title.isEmpty else {
            RemindHUD.shared().showDefaultHUD(withText: " 还没有设置标题～ ")
            return
        }
        dataModel.titleStr = title
        delegate?.sheetViewSaveBtnClicked(dataModel)
        cancel()
    }
    
    @objc private func remindTimeBtnClicked() {
        self.endEditing(true)
        self.selectRepeatView.hideView()
        self.selectTimeView.showView()
        self.backView.bringSubviewToFront(selectTimeView)
    }
    
    @objc private func repeatModelBtnClicked() {
        self.endEditing(true)
        self.selectTimeView.hideView()
        self.selectRepeatView.showView()
        self.backView.bringSubviewToFront(selectRepeatView)
    }
    
    @objc private func deleteBtnClicked() {
        UIView.animate(withDuration: 0.5) {
            self.deleteBtn.alpha = 0
        }
        remindTimeBtn.setTitle("设置提醒时间", for: .normal)
        dataModel.timeStr = ""
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        saveBtn.alpha = updatedText.isEmpty ? 0.4 : 1.0
        return true
    }
    
    // MARK: - Helper Methods
    
    private func updateButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.ry(light: "#14305B", dark: "#EFEFF1"), for: .normal)
    }
    
    func showView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height * 0.7389)
            self.backgroundColor = UIColor(hexString: "#000000", alpha: 0.4)
        })
    }
    
//    func configure(with dataModel: TodoDataModel) {
//        self.dataModel = dataModel
//        titleInputTextField.text = dataModel.titleStr
//        if let remindTime = dataModel.getTimeStrDate() {
//            updateButton(remindTimeBtn, title: "提醒时间：" + remindTime.stringWithFormat("yyyy/MM/dd HH:mm"))
//        }
//        if let repeatModel = dataModel.repeatModel {
//            updateButton(repeatModelBtn, title: "重复：" + repeatModel)
//        }
//        deleteBtn.alpha = 1
//    }
}

extension DiscoverTodoSheetView: DiscoverTodoSelectTimeViewDelegate, DiscoverTodoSelectRepeatViewDelegate {
    // MARK: - DiscoverTodoSelectTimeViewDelegate
    func selectTimeViewSureBtnClicked(components: DateComponents) {
        if let date = Calendar.current.date(from: components) {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "M月d日HH:mm"
            let btnString = dateFormatter1.string(from: date)
            remindTimeBtn.setTitle(btnString, for: .normal)
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyy年M月d日HH:mm"
            let modelTimeStr = dateFormatter2.string(from: date)
            self.dataModel.timeStr = modelTimeStr
            UIView.animate(withDuration: 0.5) {
                self.deleteBtn.alpha = 1
            }
        }
    }
    
    func selectTimeViewCancelBtnClicked() {
        
    }
    
    // MARK: - DiscoverTodoSelectRepeatViewDelegate
    func selectRepeatViewSureBtnClicked(_ view: DiscoverTodoSelectRepeatView) {
        dataModel.repeatMode = view.repeatMode
        switch view.repeatMode {
        case TodoDataModelRepeatModeWeek:
            dataModel.weekArr = view.dateArr.compactMap { $0 as? String }
            break
        case TodoDataModelRepeatModeMonth:
            dataModel.dayArr = view.dateArr.compactMap { $0 as? String }
            break
        case TodoDataModelRepeatModeYear:
            dataModel.dateArr = view.dateArr.compactMap { $0 as? [String: String] }
            break
        default: 
            break
        }
    }
    
    func selectRepeatViewCancelBtnClicked() {
        
    }
}



