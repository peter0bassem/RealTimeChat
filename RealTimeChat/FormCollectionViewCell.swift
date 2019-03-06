//
//  FormCollectionViewCell.swift
//  RealTimeChat
//
//  Created by Peter Bassem on 3/4/19.
//  Copyright © 2019 Peter Bassem. All rights reserved.
//

import UIKit

class FormCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var usernameContainer: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var slideButton: UIButton!
}
