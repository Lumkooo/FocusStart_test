//
//  AddNewCarDelegate.swift
//  FocusStart_TestTask
//
//  Created by Андрей Шамин on 9/16/20.
//  Copyright © 2020 Андрей Шамин. All rights reserved.
//

import Foundation

protocol AddNewCarDelegate {
    func cancelTapped()
    func addTapped(carMark:String, carModel:String, carBodyType:CarBodyType, carYear:String)
}
