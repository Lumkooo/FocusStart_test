//
//  SaveManager.swift
//  FocusStart_TestTask
//
//  Created by Андрей Шамин on 9/16/20.
//  Copyright © 2020 Андрей Шамин. All rights reserved.
//

import Foundation

struct SaveManager {
    /// Сохранение массива машин в UserDefaults
    static func saveToUserDefaults(_ carArray: [Car]) {
        if let encodedUserDetails = try? JSONEncoder().encode(carArray) {
            UserDefaults.standard.set(encodedUserDetails, forKey: "Car")
        }
    }
}
