//
//  DiscoverTodoSetRemindBasicView.swift
//  CyxbsMobile2019_iOS
//
//  Created by Max Xu on 2024/8/19.
//  Copyright © 2024 Redrock. All rights reserved.
//

import UIKit
import SnapKit

class DiscoverTodoSetRemindBasicView: UIView {
    
    // 紫色三角形
    var tipView: UIImageView!
    
    // 取消按钮
    var cancelBtn: UIButton!
    
    // 确定按钮
    var sureBtn: UIButton!
    
    var separatorLine: UIView!
    
    // 1代表状态为show，0为hide，子类自己去维护，父类不维护
    var isViewHided: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ry(light: "#FFFFFF", dark: "#2C2C2C")
        self.isViewHided = true
        self.alpha = 0
        addTipView()
        addCancelBtn()
        addSureBtn()
        addSeparateLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 初始化UI：
    /// 添加紫色的TipView
    private func addTipView() {
        let view = UIImageView()
        self.addSubview(view)
        self.tipView = view
        
        view.image = UIImage(named: "todo紫色提醒图标")
        
        view.snp.makeConstraints { make in
            make.width.equalTo(0.016 * SCREEN_WIDTH)
            make.height.equalTo(0.02057142857 * SCREEN_WIDTH)
        }
    }
    
    /// 添加底部的取消按钮
    private func addCancelBtn() {
        let btn = UIButton()
        self.addSubview(btn)
        self.cancelBtn = btn
        
        btn.setTitle("取消", for: .normal)
        btn.layer.cornerRadius = 20
        btn.backgroundColor = UIColor.ry(light: "#EDF4FD", dark: "#484A4D")
        
        btn.titleLabel?.font = UIFont(name: "PingFangSCSemibold", size: 18)
        btn.setTitleColor(UIColor.ry(light: "#15315B", dark: "#F0F0F2"), for: .normal)
        
        btn.snp.makeConstraints { make in
            make.left.equalTo(self).offset(0.128 * SCREEN_WIDTH)
            make.bottom.equalTo(self).offset(-0.04926108374 * SCREEN_HEIGHT)
            make.width.equalTo(0.32 * SCREEN_WIDTH)
            make.height.equalTo(0.1066666667 * SCREEN_WIDTH)
        }
    }
    
    /// 添加确定按钮
    private func addSureBtn() {
        let btn = UIButton()
        self.addSubview(btn)
        self.sureBtn = btn
        
        btn.setTitle("确定", for: .normal)
        btn.layer.cornerRadius = 20
        btn.backgroundColor = UIColor.ry(light: "#4841E2", dark: "#4841E2")
        
        btn.titleLabel?.font = UIFont(name: "PingFangSCSemibold", size: 18)
        btn.setTitleColor(.white, for: .normal)
        
        btn.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-0.128 * SCREEN_WIDTH)
            make.bottom.equalTo(self).offset(-0.04926108374 * SCREEN_HEIGHT)
            make.width.equalTo(0.32 * SCREEN_WIDTH)
            make.height.equalTo(0.1066666667 * SCREEN_WIDTH)
        }
    }
    
    /// 添加分隔线的方法
    private func addSeparateLine() {
        let view = UIView()
        self.addSubview(view)
        self.separatorLine = view
        
        view.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor.ry(light: "#2C2C2C", dark: "#E6E6E6").withAlphaComponent(0.2)
        } else {
            view.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 0.64)
        }
    }
    
    func showView() {
        // 子类实现
    }
    
    func hideView() {
        // 子类实现
    }
}

