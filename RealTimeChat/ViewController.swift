//
//  ViewController.swift
//  RealTimeChat
//
//  Created by Peter Bassem on 2/28/19.
//  Copyright © 2019 Peter Bassem. All rights reserved.
//

import UIKit
import Firebase
//import NVActivityIndicator


class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReachabilityManager.shared.addListener(listener: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ReachabilityManager.shared.removeListener(listener: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @objc func slideToSignIn(_ sender: UIButton) {
        let indexPath = IndexPath(row: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [UICollectionView.ScrollPosition.centeredHorizontally], animated: true)
    }
    
    @objc func slideToSignUp(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [UICollectionView.ScrollPosition.centeredHorizontally], animated: true)
    }
    
    @objc func didPressSignUp(_ sender: UIButton) {
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as! FormCollectionViewCell
        guard let username = cell.usernameTextField.text, let email = cell.emailAddressTextField.text, let password = cell.passwordTextField.text else { return }
        activityIndicator(isActive: true)
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                self.activityIndicator(isActive: false)
            } else {
                guard let uid = result?.user.uid else { return }
                let reference =  Database.database().reference()
                let user = reference.child("users").child(uid)
                let userDataArray: [String: Any] = ["username": username]
                user.setValue(userDataArray)
                self.activityIndicator(isActive: false)
            }
        }
    }
}

//MARK:- Reachability Delegates
extension ViewController: NetworkStatusListener {
    func networkStatusDidChange(status: Reachability.NetworkStatus) {
        switch status {
        case .notReachable:
            debugPrint("ViewController: Network became unreachable")
            showNoInternetView(isActive: false)
        case .reachableViaWiFi:
            debugPrint("ViewController: Network reachable through WiFi")
            showNoInternetView(isActive: true)
        case .reachableViaWWAN:
            debugPrint("ViewController: Network reachable through Cellular Data")
            showNoInternetView(isActive: true)
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let form_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "form_cell", for: indexPath) as! FormCollectionViewCell
        if indexPath.item == 0 {
            //Sign in
            form_cell.usernameContainer.isHidden = true
            form_cell.actionButton.setTitle("Login", for: UIControl.State.normal)
            form_cell.slideButton.setTitle("Sign Up 👉🏼", for: UIControl.State.normal)
            form_cell.slideButton.addTarget(self, action: #selector(slideToSignIn(_:)), for: UIControl.Event.touchUpInside)
        } else if indexPath.item == 1 {
            //Sign up
            form_cell.usernameContainer.isHidden = false
            form_cell.actionButton.setTitle("Sign Up", for: UIControl.State.normal)
            form_cell.slideButton.setTitle("Login 👈🏼", for: UIControl.State.normal)
            form_cell.slideButton.addTarget(self, action: #selector(slideToSignUp (_:)), for: UIControl.Event.touchUpInside)
            form_cell.actionButton.addTarget(self, action: #selector(didPressSignUp(_:)), for: UIControl.Event.touchUpInside)
        }
        return form_cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
