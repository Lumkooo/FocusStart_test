//
//  ChooseCarBodyTypeDelegate.swift
//  FocusStart_TestTask
//
//  Created by Андрей Шамин on 9/17/20.
//  Copyright © 2020 Андрей Шамин. All rights reserved.
//

import Foundation

protocol ChooseCarBodyTypeDelegate {
    func cancelTapped()
    func doneTapped(chosenCarBodyType:String)
}
