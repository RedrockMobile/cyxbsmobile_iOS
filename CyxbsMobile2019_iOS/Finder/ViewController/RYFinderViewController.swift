//
//  RYFinderViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class RYFinderViewController: UIViewController {
    
    // 适配OC
    // 体育打卡
    lazy var sportsVC = DiscoverSAVC()
    // 电费
    lazy var electricVC = ElectricViewController()
    lazy var ToDoMainPageVC: ToDoFinderVC = {
        let vc = ToDoFinderVC()
        vc.delegate = self
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(ToDoMainPageVC)
        addChild(sportsVC)
        addChild(electricVC)
        
        view.backgroundColor = .ry(light: "#F2F3F8", dark: "#000000")
        
        view.addSubview(contentScrollView)
        setupUI()
        setupToDo()
        setupElectric()
        setupSA()
        updateContentSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //刷新消息中心小圆点
        reloadData()
    }
    
    lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var headerView: RYFinderHeaderView = {
        let headerView = RYFinderHeaderView(frame: CGRect(x: marginSpaceForHorizontal, y: Constants.statusBarHeight, width: view.bounds.width - 2 * marginSpaceForHorizontal, height: 55))
        headerView.messageBtnTouched = { theView in
            let vc = MineMessageVC()
            vc.hidesBottomBarWhenPushed = true
            theView.latestViewController?.navigationController?.pushViewController(vc, animated: true)
        }
        headerView.attendanceBtnTouched = { theView in
            let vc = CheckInViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.hidesBottomBarWhenPushed = true
            theView.latestViewController?.present(vc, animated: true)
        }
        return headerView
    }()
    
    lazy var bannerView: FinderBannerView = {
        let aspectRatio: CGFloat = 343.0 / 134.0
        let width = view.bounds.width - 2 * marginSpaceForHorizontal
        let bannerView = FinderBannerView(frame: CGRect(x: marginSpaceForHorizontal, y: headerView.frame.maxY + 6, width: width, height: width / aspectRatio))
        return bannerView
    }()
    
    lazy var newsView: FinderNewsView = {
        let width = view.bounds.width - 2 * marginSpaceForHorizontal
        let newsView = FinderNewsView(frame: CGRect(x: marginSpaceForHorizontal, y: bannerView.frame.maxY + 15, width: width, height: 22))
        return newsView
    }()
    
    lazy var toolsView: FinderToolsView = {
        let width = view.bounds.width - 2 * marginSpaceForHorizontal
        let toolsView = FinderToolsView(frame: CGRect(x: marginSpaceForHorizontal, y: newsView.frame.maxY + 20, width: width, height: 70))
        return toolsView
    }()
}

extension RYFinderViewController {
    
    var marginSpaceForHorizontal: CGFloat { 16 }
    
    func setupUI() {
        contentScrollView.addSubview(headerView)
        contentScrollView.addSubview(bannerView)
        contentScrollView.addSubview(newsView)
        contentScrollView.addSubview(toolsView)
    }
    
    func setupToDo() {
        ToDoMainPageVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 152)
        ToDoMainPageVC.view.frame.origin.y = toolsView.frame.maxY + 20
        contentScrollView.addSubview(ToDoMainPageVC.view)
    }
    
    func setupElectric() {
        electricVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 152)
        electricVC.view.frame.origin.y = ToDoMainPageVC.view.frame.maxY
        contentScrollView.addSubview(electricVC.view)
    }
    
    func setupSA() {
        sportsVC.view.frame = CGRectMake(0, electricVC.view.frame.maxY, SCREEN_WIDTH, 152)
        contentScrollView.addSubview(sportsVC.view)
    }
    
    func reloadData() {
        headerView.reloadData()
        bannerView.request()
    }
    
    func updateContentSize() {
        var contentHeight = SCREEN_HEIGHT
        for subView in contentScrollView.subviews {
            contentHeight = max(contentHeight, subView.frame.maxY)
        }
        contentHeight += 107 + Constants.safeDistanceBottom
        contentScrollView.contentSize = CGSize(width: contentScrollView.frame.width, height: contentHeight)
    }
}

extension RYFinderViewController: ToDoFinderVCDelegate {
    func updateContentSize(size: CGSize) {
        ToDoMainPageVC.view.frame = CGRectMake(0, toolsView.frame.maxY + 20, size.width, size.height)
        electricVC.view.frame.origin.y = ToDoMainPageVC.view.frame.maxY
        sportsVC.view.frame.origin.y = electricVC.view.frame.maxY
        updateContentSize()
        // 强制更新布局
    }
}
