//
//  DiscoverTodoSelectTimeView.swift
//  CyxbsMobile2019_iOS
//
//  Created by Max Xu on 2024/8/20.
//  Copyright © 2024 Redrock. All rights reserved.
//

import UIKit
import SnapKit

protocol DiscoverTodoSelectTimeViewDelegate: AnyObject {
    func selectTimeViewSureBtnClicked(components: DateComponents)
    func selectTimeViewCancelBtnClicked()
}

class DiscoverTodoSelectTimeView: DiscoverTodoSetRemindBasicView {
    
    weak var delegate: DiscoverTodoSelectTimeViewDelegate?
    
    private var datePicker: UIDatePicker!
    private var yearBtnsView: YearBtnsView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addDatePicker()
        addYearBtnsView()
        layoutTipView()
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
        sureBtn.addTarget(self, action: #selector(sureBtnClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 初始化UI
    private func addYearBtnsView() {
        let view = YearBtnsView()
        yearBtnsView = view
        addSubview(view)
        
        view.delegate = self
        
        view.snp.makeConstraints { make in
            make.top.equalTo(self).offset(0.0197044335 * UIScreen.main.bounds.height)
            make.left.equalTo(self).offset(0.04266666667 * UIScreen.main.bounds.width)
            make.right.equalTo(self).offset(-0.04266666667 * UIScreen.main.bounds.width)
            make.height.equalTo(0.04926108374 * UIScreen.main.bounds.height)
        }
    }
    
    /// 添加日期选择器
    private func addDatePicker() {
        let datePicker = UIDatePicker()
        self.datePicker = datePicker
        addSubview(datePicker)
        
        // 本地化设置为中国，24小时制
        datePicker.locale = Locale(identifier: "zh_CHT")
        
        // 最少十分钟后
        let date = Date(timeIntervalSinceNow: 60)
        datePicker.date = date
        datePicker.minimumDate = date
        
        // iOS 13.4 之后设置成滑轮样式
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        // 设置成本地时区
        datePicker.timeZone = .current
        
        datePicker.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(0.059408867 * UIScreen.main.bounds.height)
            make.bottom.equalTo(self).offset(-0.1477832512 * UIScreen.main.bounds.height)
        }
    }
    
    /// 为紫色的tipView布局
    private func layoutTipView() {
        tipView.snp.makeConstraints { make in
            make.centerY.equalTo(datePicker)
            make.right.equalTo(datePicker.snp.left)
        }
    }
    
    /// 下方的取消按钮点击后调用
    @objc private func cancelBtnClicked() {
        hideView()
        delegate?.selectTimeViewCancelBtnClicked()
    }
    
    /// 下方的确定按钮点击后调用
    @objc private func sureBtnClicked() {
        hideView()
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: datePicker.date)
        components.timeZone = .current
        delegate?.selectTimeViewSureBtnClicked(components: components)
    }
    
    /// 外界调用，调用后显示出来
    override func showView() {
        print("\(isViewHided), \(self.alpha)")
        if isViewHided == true {
            isViewHided = false
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
            }
        }
    }
    
    /// 调用后效果如同点击取消按钮，但是不会调用代理方法
    override func hideView() {
        if isViewHided == false {
            isViewHided = true
            UIView.animate(withDuration: 0.5) {
                self.alpha = 0
            }
        }
    }
}

extension DiscoverTodoSelectTimeView: YearBtnsViewDelegate {
    func yearBtnsView(_ view: YearBtnsView, didSelectedYear year: Int) {
        let calendar = Calendar.current
        var minDate: Date
        var maxDate: Date
        
        var components = DateComponents()
        components.year = year + 1
        maxDate = calendar.date(from: components)!.addingTimeInterval(-1)
        
        if calendar.component(.year, from: Date()) == year {
            minDate = Date(timeIntervalSinceNow: 60)
        } else {
            components.year = year
            minDate = calendar.date(from: components)!
        }
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
}

