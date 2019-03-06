//
//  AlertView.swift
//  CustomAlert
//
//  Created by SHUBHAM AGARWAL on 31/12/18.
//  Copyright © 2018 SHUBHAM AGARWAL. All rights reserved.
//

//NOTE:
//Don't Forget to add images from resources to Assets.xcassets

import Foundation
import UIKit

class AlertViewWithTwoButtons: UIView {
    
    static let instance = AlertViewWithTwoButtons()
    
    var onCancelClicked: (()->Void)?
    var onDoneClicked: (()->Void)?
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertViewWithTwoButtons", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        
        alertView.layer.cornerRadius = 10
        
        titleLabel.font = setFont(size: 22.0, isBold: true)
        
        messageLabel.font = setFont(size: 19.0, isBold: false)
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        cancelButton.titleLabel?.font = setFont(size: 17.0, isBold: false)
        cancelButton.layer.cornerRadius = 10
        cancelButton.backgroundColor = COLORS.lightGrayViewBackgroundColor
        cancelButton.setTitleColor(COLORS.textPrimaryColor, for: UIControl.State.normal)
        
        doneButton.titleLabel?.font = setFont(size: 17.0, isBold: false)
        doneButton.layer.cornerRadius = 10
        doneButton.backgroundColor = COLORS.mainColor
        doneButton.setTitleColor(COLORS.textPrimaryColor, for: UIControl.State.normal)
        
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    enum AlertViewWithTwoButtonsType {
        case success
        case failure
    }
    
    func showAlert(title: String, message: String, leftButtonTitle: String?, rightButtonTitle: String?, alertType: AlertViewWithTwoButtonsType, onCancelCompletion leftButtonCompletion: (() -> Void)?, onDoneCompletion rightButtonCompletion: (() -> Void)?) {
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.cancelButton.setTitle(leftButtonTitle ?? LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancelButton", comment: ""), for: UIControl.State.normal)
        self.doneButton.setTitle(rightButtonTitle ?? LocalizationSystem.sharedInstance.localizedStringForKey(key: "doneButton", comment: ""), for: UIControl.State.normal)
        
        switch alertType {
        case .success:
            imageView.image = UIImage(named: "success")
            doneButton.backgroundColor = COLORS.mainColor
            doneButton.tag = 0
        case .failure:
            imageView.image = UIImage(named: "Failure")
            doneButton.backgroundColor = COLORS.alertViewErrorColor
            doneButton.tag = 1
        }
        self.onCancelClicked = leftButtonCompletion
        self.onDoneClicked = rightButtonCompletion
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        onCancelClicked?()
        parentView.removeFromSuperview()
    }
    
    @IBAction func onClickDone(_ sender: UIButton) {
        onDoneClicked?()
        parentView.removeFromSuperview()
    }
    
//    @IBAction func onClickDone(_ sender: UIButton) {
//         onDoneClicked?()
//        parentView.removeFromSuperview()
//    }
}
