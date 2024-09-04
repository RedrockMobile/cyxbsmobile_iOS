//
//  ToDoFinderVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by Max Xu on 2024/9/2.
//  Copyright © 2024 Redrock. All rights reserved.
//

import UIKit
import SnapKit

protocol ToDoFinderVCDelegate: AnyObject {
    func updateContentSize(size: CGSize)
}

class ToDoFinderVC: UIViewController {
    
    weak var delegate: ToDoFinderVCDelegate?
    /// 全部待办数据
    private var entireToDoAry: [TodoDataModel] = []
    
    // MARK: - Lazy
    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .ry(light: "#15315B", dark: "#F0F0F2")
        label.text = "邮子清单"
        label.frame = CGRectMake(14, 23, 74, 25)
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 0
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoTopExpiredStyleCell.self, forCellReuseIdentifier: ToDoTopExpiredStyleCellReuseIdentifier)
        tableView.register(ToDoTopActiveStyleCell.self, forCellReuseIdentifier: ToDoTopActiveStyleCellReuseIdentifier)
        tableView.register(ToDoTopNoDeadlineStyleCell.self, forCellReuseIdentifier: ToDoTopNoDeadlineStyleCellReuseIdentifier)
        tableView.register(ToDoNonTopExpiredStyleCell.self, forCellReuseIdentifier: ToDoNonTopExpiredStyleCellReuseIdentifier)
        tableView.register(ToDoNonTopActiveStyleCell.self, forCellReuseIdentifier: ToDoNonTopActiveStyleCellReuseIdentifier)
        tableView.register(ToDoNonTopNoDeadlineStyleCell.self, forCellReuseIdentifier: ToDoNonTopNoDeadlineStyleCellReuseIdentifier)
        tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 152)
        return tableView
    }()
    
    lazy var seperateLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(light: UIColor(hexString: "#2A4E84", alpha: 0.1), dark: UIColor(hexString: "#2D2D2D", alpha: 0.5))
        return view
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ry(light: "#F8F9FC", dark: "#1D1D1D")
        // 只切上面的圆角
        let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1000), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 16, height: 16))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
        // 设置阴影
        view.layer.shadowOpacity = 0.33
        view.layer.shadowColor = UIColor.hex("#AEB6D3").cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -5)
        view.addSubview(titleLab)
        view.addSubview(tableView)
        view.addSubview(seperateLine)
        seperateLine.snp.makeConstraints { make in
            make.width.equalTo(view.width)
            make.height.equalTo(1)
            make.bottom.equalTo(view.snp.bottom)
        }
        getToDoData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let newsize = CGSizeMake(tableView.contentSize.width, tableView.contentSize.height + 86)
        delegate?.updateContentSize(size: newsize)
    }
    
    // 获取每种todo待办,置顶的待办在上
    private func getToDoData() {
        entireToDoAry.removeAll()
        var entireNotPinnedAry: [TodoDataModel] = []
        let tool = TodoSyncTool.share()
        for model in tool.getTodoForMainPage() {
            if model.isPinned {
                entireToDoAry.append(model)
            } else{
                entireNotPinnedAry.append(model)
            }
        }
        entireToDoAry.append(contentsOf: entireNotPinnedAry)
        tableView.reloadData()
        tableView.size.height = tableView.contentSize.height
//        isRowSelected = Array(repeating: false, count: entireToDoAry.count)
        
//        if entireToDoAry.count == 0 {
//            view.addSubview(todoEmptyView)
//            view.bringSubviewToFront(addToDoBtn)
//        } else {
//            todoEmptyView.removeFromSuperview()
//        }
    }
    
    // 配置左滑的删除按钮
    private func configDeleteButton(_ button: UIButton, model: TodoDataModel) {
        button.backgroundColor = UIColor(.dm, light: UIColor(hexString: "#FF6262", alpha: 1), dark: UIColor(hexString: "#FF6262", alpha: 1))
        
        let cellBtn = UIButton()
        cellBtn.frame = button.frame
        cellBtn.setImage(UIImage(named: "todo删除"), for: .normal)
        cellBtn.setTitle("删除", for: .normal)
        cellBtn.titleLabel?.font = .systemFont(ofSize: 14)
        cellBtn.setTitleColor(UIColor(.dm, light: UIColor(hexString: "#FFFFFF", alpha: 1), dark: UIColor(hexString: "#FFFFFF", alpha: 1)), for: .normal)
        if model.timeStr.isEmpty && model.overdueTimeStr.isEmpty {
            horizontalImgAndTextOnBtn(cellBtn)
        } else {
            centerImgAndTextOnBtn(cellBtn)
        }
        button.addSubview(cellBtn)
    }
    
    // 配置左滑的置顶按钮
    private func configStickyButton(_ button: UIButton, model: TodoDataModel) {
        button.backgroundColor = UIColor(.dm, light: UIColor(hexString: "#5263FF", alpha: 1), dark: UIColor(hexString: "#5263FF", alpha: 1))
        
        let cellBtn = UIButton()
        cellBtn.frame = button.frame
        cellBtn.setImage(UIImage(named: "置顶"), for: .normal)
        cellBtn.setTitle("置顶", for: .normal)
        cellBtn.titleLabel?.font = .systemFont(ofSize: 14)
        cellBtn.setTitleColor(UIColor(.dm, light: UIColor(hexString: "#FFFFFF", alpha: 1), dark: UIColor(hexString: "#FFFFFF", alpha: 1)), for: .normal)
        if model.timeStr.isEmpty && model.overdueTimeStr.isEmpty {
            horizontalImgAndTextOnBtn(cellBtn)
        } else {
            centerImgAndTextOnBtn(cellBtn)
        }
        button.addSubview(cellBtn)
    }
    
    // 按钮图片文字上下居中
    private func centerImgAndTextOnBtn(_ button: UIButton) {
        let imgSize = button.imageView?.size ?? CGSize.zero
        let titleSize = button.titleLabel?.size ?? CGSize.zero
        button.titleEdgeInsets = UIEdgeInsets(top: imgSize.height / 2, left: -(imgSize.width / 2), bottom: -(imgSize.height / 2), right: imgSize.width / 2)
        button.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height / 2 + 3), left: titleSize.width / 2, bottom: titleSize.height / 2 + 3, right: -(titleSize.width / 2))
    }
    
    // 按钮图片文字左右分布
    private func horizontalImgAndTextOnBtn(_ button: UIButton) {
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
    }
    
    // 删除tableview对应的model
    private func deleteTableViewModel(_ model: TodoDataModel) {
        if let index = self.entireToDoAry.firstIndex(of: model) {
            self.entireToDoAry.remove(at: index)
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
//        if entireToDoAry.count == 0 {
//            view.addSubview(todoEmptyView)
//            view.bringSubviewToFront(addToDoBtn)
//        } else {
//            todoEmptyView.removeFromSuperview()
//        }
    }
}

// MARK: - UITableViewDataSource

extension ToDoFinderVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entireToDoAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = entireToDoAry[indexPath.row]
        
        let isTop = data.isPinned ? true : false
        let haveTime: Bool
        var expired = false
        
        if data.overdueTimeStr != "" || data.timeStr != "" {
            haveTime = true
            if data.overdueTime < Int(Date().timeIntervalSince1970) {
                expired = true
            } else {
                expired = false
            }
        } else {
            haveTime = false
        }
        
        let cell: ToDoTableViewCell
        let identifier: String
        
        if isTop, haveTime, expired {
            identifier = ToDoTopExpiredStyleCellReuseIdentifier
        } else if isTop, haveTime, !expired {
            identifier = ToDoTopActiveStyleCellReuseIdentifier
        } else if isTop, !haveTime {
            identifier = ToDoTopNoDeadlineStyleCellReuseIdentifier
        } else if !isTop, haveTime, expired {
            identifier = ToDoNonTopExpiredStyleCellReuseIdentifier
        } else if !isTop, haveTime, !expired {
            identifier = ToDoNonTopActiveStyleCellReuseIdentifier
        } else {
            identifier = ToDoNonTopNoDeadlineStyleCellReuseIdentifier
        }
        
        cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ToDoTableViewCell
        cell.selectionStyle = .none
        cell.button.tag = indexPath.row
        cell.contentLab.text = data.titleStr
        cell.timeLab.text = data.overdueTimeStr.isEmpty ? data.timeStr : data.overdueTimeStr
//        cell.delegate = self
        if expired {
            cell.button.setBackgroundImage(UIImage(named: "ToDo过期圆圈"), for: .normal)
        } else {
            cell.button.setBackgroundImage(UIImage(named: "未完成圆圈"), for: .normal)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ToDoFinderVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = entireToDoAry[indexPath.row]
        return (data.timeStr.isEmpty && data.overdueTimeStr.isEmpty) ? 49 : 67
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ToDoDetailVC(model: entireToDoAry[indexPath.row]), animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let model = self.entireToDoAry[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: " ") { action, sourceView, completionHandler in
            self.deleteTableViewModel(self.entireToDoAry[indexPath.row])
            TodoSyncTool.share().deleteTodo(withTodoID: model.todoIDStr, needRecord: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                tableView.reloadData()
            }
        }
        deleteAction.backgroundColor = UIColor(.dm, light: UIColor(hexString: "#FF6262", alpha: 1), dark: UIColor(hexString: "#FF6262", alpha: 1))

        let stickyAction = UIContextualAction(style: .destructive, title: " ") { action, sourceView, completionHandler in
            model.isPinned = true
            model.lastModifyTime = Int(Date().timeIntervalSince1970)
            model.resetOverdueTime(NSDate.nowTimestamp())
            TodoSyncTool.share().alterTodo(with: model, needRecord: true)
            self.getToDoData()
            tableView.reloadData()
        }
        stickyAction.backgroundColor = UIColor(.dm, light: UIColor(hexString: "#5263FF", alpha: 1), dark: UIColor(hexString: "#5263FF", alpha: 1))
        
        let action: [UIContextualAction]
        if model.isPinned {
            action = [deleteAction]
        } else {
            action = [deleteAction, stickyAction]
        }
        let configuration = UISwipeActionsConfiguration(actions: action)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        var model = entireToDoAry[indexPath.row]
        if #available(iOS 13.0, *) {
            for subView in tableView.subviews {
                if let cellSwipeContainerClass = NSClassFromString("_UITableViewCellSwipeContainerView") {
                    if subView.isKind(of: cellSwipeContainerClass),
                       subView.subviews.count >= 1 {
                        let swipeView = subView.subviews.first
                        swipeView?.backgroundColor = .clear
                        if !model.isPinned,
                           swipeView?.subviews.count ?? 0 >= 2 {
                            let deleteBtn = swipeView?.subviews[1]
                            let stickyBtn = swipeView?.subviews[0]
                            configDeleteButton(deleteBtn as! UIButton, model: model)
                            configStickyButton(stickyBtn as! UIButton, model: model)
                        } else if model.isPinned,
                                  swipeView?.subviews.count ?? 0 >= 1 {
                            let deleteBtn = swipeView?.subviews[0]
                            configDeleteButton(deleteBtn as! UIButton, model: model)
                        }
                    }
                }
            }
            
        } else if #available(iOS 11.0, *) {
            for subView in tableView.subviews {
                if let wrapperClass = NSClassFromString("UITableViewWrapperView") {
                    if subView.isKind(of: wrapperClass) {
                        for actionView in subView.subviews {
                            if let swipeActionPullClass = NSClassFromString("UISwipeActionPullView") {
                                if actionView.isKind(of: swipeActionPullClass) {
                                    actionView.backgroundColor = .clear
                                    if !model.isPinned,
                                       actionView.subviews.count >= 2 {
                                        let deleteBtn = actionView.subviews[1]
                                        let stickyBtn = actionView.subviews[0]
                                        configDeleteButton(deleteBtn as! UIButton, model: model)
                                        configStickyButton(stickyBtn as! UIButton, model: model)
                                    } else if model.isPinned,
                                              actionView.subviews.count >= 1 {
                                        let deleteBtn = actionView.subviews[0]
                                        configDeleteButton(deleteBtn as! UIButton, model: model)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        } else {
            let tableCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))!
            for subView in tableCell.subviews {
                if let cellDeleteConfirmationClass = NSClassFromString("UITableViewCellDeleteConfirmationView") {
                    if subView.isKind(of: cellDeleteConfirmationClass) {
                        if !model.isPinned,
                           subView.subviews.count >= 2 {
                            let deleteBtn = subView.subviews[1]
                            let stickyBtn = subView.subviews[0]
                            configDeleteButton(deleteBtn as! UIButton, model: model)
                            configStickyButton(stickyBtn as! UIButton, model: model)
                        } else if model.isPinned,
                                  subView.subviews.count >= 1 {
                            let deleteBtn = subView.subviews[0]
                            configDeleteButton(deleteBtn as! UIButton, model: model)
                        }
                    }
                }
            }
        }
    }
}

