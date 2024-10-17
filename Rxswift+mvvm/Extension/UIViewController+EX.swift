//
//  UIViewController+EX.swift
//  GHDemo
//
//  Created by zzh on 2024/10/5.
//

import UIKit

extension UIViewController {
    
    
    static func setTabbarShow(){
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            UITabBar.appearance().scrollEdgeAppearance = appearance
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().backgroundColor = UIColor.systemBackground
        }
    }
    // 全局设置导航栏隐藏
    static func setNavShow(){
        
        //navigation标题文字颜色
        let dic = [NSAttributedString.Key.foregroundColor : UIColor.black,
                   NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium)];
        if #available(iOS 15.0, *) {
            let barApp = UINavigationBarAppearance();
            barApp.configureWithOpaqueBackground() // 重置成系统设置自
            barApp.configureWithTransparentBackground() // 重置成系统设置自
            barApp.configureWithDefaultBackground() // 重置成系统设置自
            barApp.backgroundColor = .white;
            barApp.shadowColor = .white;
            barApp.titleTextAttributes = dic;
            UINavigationBar.appearance().scrollEdgeAppearance = barApp
            UINavigationBar.appearance().standardAppearance = barApp
        }else{
            //背景色
            UINavigationBar.appearance().barTintColor = .white
            UINavigationBar.appearance().titleTextAttributes = dic
            UINavigationBar.appearance().shadowImage = nil
            UINavigationBar.appearance().setBackgroundImage(nil, for: .default)
        }
        //不透明
        UINavigationBar.appearance().isTranslucent = false;
        //navigation控件颜色 渲染色 不需要使用
        //UINavigationBar.appearance().tintColor = .black;
    }
    
    static func setNavHidden(){
        
        //navigation标题文字颜色
        let dic = [NSAttributedString.Key.foregroundColor : UIColor.black,
                   NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium)];
        if #available(iOS 15.0, *) {
            let barApp = UINavigationBarAppearance();
            barApp.configureWithOpaqueBackground() // 重置成系统设置自
            barApp.configureWithTransparentBackground() // 重置成系统设置自 
            barApp.configureWithDefaultBackground() // 重置成系统设置自
            barApp.backgroundEffect = nil
            barApp.backgroundColor = .clear;
            barApp.shadowColor = nil;
            barApp.titleTextAttributes = dic;
            UINavigationBar.appearance().scrollEdgeAppearance = nil
            UINavigationBar.appearance().standardAppearance = barApp
        }else{
            //背景色
            UINavigationBar.appearance().barTintColor = .white
            UINavigationBar.appearance().titleTextAttributes = dic
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        }
        //透明
        UINavigationBar.appearance().isTranslucent = true;
        //navigation控件颜色 渲染色 不需要使用
        //UINavigationBar.appearance().tintColor = .black;
    }
    
    // 设置当前controller导航栏隐藏注意页面好多vc共用一个导航栏
    func setCurrentNavShow(){
        
        //navigation标题文字颜色
        let dic = [NSAttributedString.Key.foregroundColor : UIColor.black,
                   NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium)];
        if #available(iOS 15.0, *) {
            let barApp = UINavigationBarAppearance();
            barApp.configureWithOpaqueBackground() // 重置成系统设置自
            barApp.configureWithTransparentBackground() // 重置成系统设置自
            barApp.configureWithDefaultBackground() // 重置成系统设置自
            barApp.backgroundColor = .white;
            barApp.shadowColor = .white;
            barApp.titleTextAttributes = dic;
            self.navigationController?.navigationBar.scrollEdgeAppearance = barApp
            self.navigationController?.navigationBar.standardAppearance = barApp
        }else{
            //背景色
            self.navigationController?.navigationBar.barTintColor = .white
            self.navigationController?.navigationBar.titleTextAttributes = dic
            self.navigationController?.navigationBar.shadowImage = nil
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        }
        //不透明
        self.navigationController?.navigationBar.isTranslucent = false;
        //navigation控件颜色 渲染色 不需要使用
        //self.navigationController?.navigationBar.tintColor = .black;
    }
    
    func setCurrentNavHidden(){
        
        //navigation标题文字颜色
        let dic = [NSAttributedString.Key.foregroundColor : UIColor.black,
                   NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium)];
        if #available(iOS 15.0, *) {
            let barApp = UINavigationBarAppearance();
            barApp.configureWithOpaqueBackground() // 重置成系统设置自
            barApp.configureWithTransparentBackground() // 重置成系统设置自 
            barApp.configureWithDefaultBackground() // 重置成系统设置自
            barApp.backgroundEffect = nil
            barApp.backgroundColor = .clear;
            barApp.shadowColor = nil;
            barApp.titleTextAttributes = dic;
            self.navigationController?.navigationBar.scrollEdgeAppearance = nil
            self.navigationController?.navigationBar.standardAppearance = barApp
        }else{
            //背景色
            self.navigationController?.navigationBar.barTintColor = .white
            self.navigationController?.navigationBar.titleTextAttributes = dic
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
        //透明
        self.navigationController?.navigationBar.isTranslucent = true;
        //navigation控件颜色 渲染色 不需要使用
        //self.navigationController?.navigationBar.tintColor = .black;
    }
    
    // 弹框
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
