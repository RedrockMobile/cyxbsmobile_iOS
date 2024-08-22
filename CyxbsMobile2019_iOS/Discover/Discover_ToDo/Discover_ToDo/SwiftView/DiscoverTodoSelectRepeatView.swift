//
//  DiscoverTodoSelectRepeatView.swift
//  CyxbsMobile2019_iOS
//
//  Created by Max Xu on 2024/8/19.
//  Copyright © 2024 Redrock. All rights reserved.
//

import UIKit
import SnapKit

protocol DiscoverTodoSelectRepeatViewDelegate: AnyObject {
    func selectRepeatViewSureBtnClicked(_ view: DiscoverTodoSelectRepeatView)
    func selectRepeatViewCancelBtnClicked()
}

class DiscoverTodoSelectRepeatView: DiscoverTodoSetRemindBasicView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    var dateArr: [Any] = []
    var repeatMode: TodoDataModelRepeatMode = TodoDataModelRepeatModeNO
    weak var delegate: DiscoverTodoSelectRepeatViewDelegate?
    var btnArr: [DLTimeSelectedButton] = []
    /// 数据选择器
    private var pickerView: UIPickerView!
    /// 周几的数组
    private var week: [String] = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    private var days: [Int] = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    private var addBtn: UIButton!
    private var scrollView: UIScrollView!
    private var scrContenView: UIView!
    private var selectedCntOfcom: [Int] = Array(repeating: 0, count: 3)
    private var increseCnt: Int = 0
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addPickerView()
        layoutTipView()
        addAddBtn()
        addScrollView()
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
        sureBtn.addTarget(self, action: #selector(sureBtnClicked), for: .touchUpInside)
    }
    
    private func addPickerView() {
        pickerView = UIPickerView()
        addSubview(pickerView)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(0.039 * UIScreen.main.bounds.height)
            make.bottom.equalTo(self).offset(-0.147 * UIScreen.main.bounds.height)
        }
    }
    
    private func layoutTipView() {
        tipView.snp.makeConstraints { make in
            make.centerY.equalTo(pickerView)
            make.right.equalTo(pickerView.snp.left)
        }
    }
    
    private func addAddBtn() {
        addBtn = UIButton()
        addSubview(addBtn)
        
        addBtn.setImage(UIImage(named: "加号"), for: .normal)
        addBtn.addTarget(self, action: #selector(addBtnClicked), for: .touchUpInside)
        
        addBtn.snp.makeConstraints { make in
            make.left.equalTo(pickerView.snp.right)
            make.centerY.equalTo(pickerView)
            make.width.height.equalTo(0.058 * UIScreen.main.bounds.width)
        }
    }
    
    private func addScrollView() {
        scrollView = UIScrollView()
        addSubview(scrollView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(0.017 * UIScreen.main.bounds.height)
            make.height.equalTo(0.044 * UIScreen.main.bounds.height)
        }
        
        scrContenView = UIView()
        scrollView.addSubview(scrContenView)
        
        scrContenView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
        }
    }
    
    // MARK: - UIPickerViewDataSource & UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return selectedCntOfcom[0] > 1 ? selectedCntOfcom[0] : selectedCntOfcom[0] + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 4
        }
        switch selectedCntOfcom[0] {
        case 0: return 4
        case 1: return 7
        case 2: return 31
        case 3:
            if component == 1 {
                return 12
            } else {
                return days[selectedCntOfcom[1]]
            }
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return ["每天", "每周", "每月", "每年"][row]
        case 1:
            if selectedCntOfcom[0] == 1 {
                return week[row]
            }
            fallthrough
        default: return "\(row + 1)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0, !btnArr.isEmpty, row != selectedCntOfcom[component] {
            pickerView.selectRow(selectedCntOfcom[component], inComponent: 0, animated: true)
            // Display error HUD (assuming NewQAHud is a custom HUD class)
            // NewQAHud.showHudAtWindow(withStr: "只能选择一种重复模式～", enableInteract: true)
            return
        }
        selectedCntOfcom[component] = row
        resetData()
    }
    
    private func resetData() {
        let componentCnt = numberOfComponents(in: pickerView)
        for i in 0..<componentCnt {
            let rowCnt = pickerView(pickerView, numberOfRowsInComponent: i)
            if selectedCntOfcom[i] >= rowCnt {
                selectedCntOfcom[i] = rowCnt - 1
            }
        }
        pickerView.reloadAllComponents()
        for i in 0..<componentCnt {
            pickerView.selectRow(selectedCntOfcom[i], inComponent: i, animated: true)
        }
    }
    
    // MARK: - Button Actions
    @objc private func cancelBtnClicked() {
        hideView()
        delegate?.selectRepeatViewCancelBtnClicked()
    }
    
    @objc private func sureBtnClicked() {
        UIView.animate(withDuration: 0.3) {
            self.addBtn.alpha = 0
            self.tipView.alpha = 0
            self.pickerView.alpha = 0
            self.sureBtn.alpha = 0
            self.cancelBtn.alpha = 0
            self.separatorLine.alpha = 0
        }
        increseCnt = 0
        isViewHided = true
        delegate?.selectRepeatViewSureBtnClicked(self)
    }
    
    @objc func addBtnClicked() {
        var titleStr: String?
        
        switch selectedCntOfcom[0] {
        case 0:
            if !btnArr.isEmpty {
                return
            }
            repeatMode = TodoDataModelRepeatModeDay
            titleStr = "每天"
            
        case 1:
            let dateStr = "\(ForeignWeekToChinaWeek(Int(selectedCntOfcom[1]) + 1))"
            if dateArr.contains(where: { $0 as? String == dateStr }) {
                return
            }
            dateArr.append(dateStr)
            repeatMode = TodoDataModelRepeatModeWeek
            titleStr = week[Int(selectedCntOfcom[1])]
            
        case 2:
            let dateStr = "\(selectedCntOfcom[1] + 1)"
            if dateArr.contains(where: { $0 as? String == dateStr }) {
                return
            }
            dateArr.append(dateStr)
            repeatMode = TodoDataModelRepeatModeMonth
            titleStr = "每月\(selectedCntOfcom[1] + 1)日"
            
        case 3:
            // 创建字典，表示用户选择的月份和日期
            let dateDict: [String: String] = [
                TodoDataModelKeyMonth: "\(selectedCntOfcom[1] + 1)", // 月份
                TodoDataModelKeyDay: "\(selectedCntOfcom[2] + 1)"   // 日期
            ]

            // 检查 dateArr 数组中是否已经存在相同的字典
            if dateArr.contains(where: { element in
                // 将 element 转换为 [String: String] 类型
                if let dict = element as? [String: String] {
                    // 检查字典是否相同
                    return dict == dateDict
                }
                return false
            }) {
                return // 如果存在相同的字典，直接返回
            }

            // 如果 dateArr 中不包含相同的字典，添加新的字典到数组中
            dateArr.append(dateDict)

            // 设置重复模式为年
            repeatMode = TodoDataModelRepeatModeYear

            // 设置标题字符串
            titleStr = "每年\(selectedCntOfcom[1] + 1)月\(selectedCntOfcom[2] + 1)日"
            
        default:
            break
        }
        
        let btn = DLTimeSelectedButton()
        btnArr.append(btn)
        scrContenView.addSubview(btn)
        
        btn.setTitle(titleStr, for: .normal)
        btn.delegate = self
        
        reLayoutAllBtn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let x = self.scrollView.contentSize.width - UIScreen.main.bounds.width
            if x > 60 {
                UIView.animate(withDuration: 0.6, animations: {
                    self.scrollView.contentOffset = CGPoint(x: x + 4, y: 0)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.4) {
                        self.scrollView.contentOffset = CGPoint(x: x, y: 0)
                    }
                })
            }
        }
        increseCnt += 1
    }

    
    private func reLayoutAllBtn() {
        let btnCnt = btnArr.count
        let btnSpacing = 15.0
        let btnWidth = 50.0
        let btnHeight = 30.0
        
        scrContenView.snp.updateConstraints { make in
            make.width.equalTo((btnWidth + btnSpacing) * Double(btnCnt))
        }
        
        for i in 0..<btnCnt {
            let btn = btnArr[i]
            btn.snp.remakeConstraints { make in
                make.left.equalTo(scrContenView.snp.left).offset(btnSpacing * Double(i) + btnWidth * Double(i))
                make.width.equalTo(btnWidth)
                make.height.equalTo(btnHeight)
                make.centerY.equalTo(scrContenView)
            }
        }
    }
    
    // MARK: - DLTimeSelectedButtonDelegate
    func timeSelectedButtonClicked(_ btn: DLTimeSelectedButton) {
        guard let index = btnArr.firstIndex(of: btn) else { return }
        
        btnArr.remove(at: index)
        btn.removeFromSuperview()
        
        if btnArr.isEmpty {
            increseCnt = 0
        }
        
        if selectedCntOfcom[0] == 3 {
            dateArr.remove(at: index)
        } else {
            dateArr.remove(at: index)
        }
        
        reLayoutAllBtn()
    }
}

extension DiscoverTodoSelectRepeatView {
    // 从 [1, 2, ... 7] 转化为 [2, 3, ... 1]
    func ChinaWeekToForeignWeek(_ week: Int) -> Int {
        return (week % 7) + 1
    }

    // 从 [2, 3, ... 1] 转化为 [1, 2, ... 7]
    func ForeignWeekToChinaWeek(_ week: Int) -> Int {
        return ((week + 5) % 7) + 1
    }
}

extension DiscoverTodoSelectRepeatView: DLTimeSelectedButtonDelegate {
    func deleteButton(with button: DLTimeSelectedButton) {
        button.removeFromSuperview()
        
        // 避免在每天重复的情况下出问题
        if !dateArr.isEmpty {
            if let index = btnArr.firstIndex(of: button) {
                dateArr.remove(at: index)
            }
        }
        
        btnArr.removeAll { $0 == button }
        reLayoutAllBtn()
        increseCnt -= 1
    }

}

