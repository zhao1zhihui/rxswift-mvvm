//
//  SearchVC.swift
//  GHDemo
//
//  Created by zzh on 2024/10/4.
//

import UIKit
import SnapKit

class SearchVC: UIViewController {
    
    let logoImageView = UIImageView()
    let usernameTextField = GFTextField()
    let callToActionButton = GFButton(backgroudColor: .systemGreen, title: "Get Followers")
    

    var isUsernameEnntered:Bool {
        return !usernameTextField.text!.isEmpty
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureMargins()
        createDismissKeyBoardTapGesture()
        // Do any additional setup after loading the view.
    }
    func createDismissKeyBoardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        UIViewController.setNavHidden()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        UIViewController.setNavShow()
    }
    
    func configureMargins(){
        
        view.addSubview(logoImageView)
        view.addSubview(usernameTextField)
        view.addSubview(callToActionButton)

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp_centerXWithinMargins)
            make.top.equalTo(self.view.snp_topMargin).offset(80)
            make.width.height.equalTo(200)
        }
        usernameTextField.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp_centerXWithinMargins)
            make.top.equalTo(self.logoImageView.snp.bottom).offset(80)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        callToActionButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp_centerXWithinMargins)
            make.bottom.equalTo(self.view.safeAreaInsets.bottom).offset(-180)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        usernameTextField.delegate = self
        
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
    }
    @objc func pushFollowerListVC(){
        
        
        if isUsernameEnntered {
            let followerVC = FollowerLisrVC()
            followerVC.username = usernameTextField.text
            followerVC.title = usernameTextField.text
            followerVC.viewModel = FollowerListVM()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(followerVC, animated: true)
            hidesBottomBarWhenPushed = false

        }else{
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 😀.", buttonTitle: "Ok")
        }
    }
}

extension SearchVC :UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
