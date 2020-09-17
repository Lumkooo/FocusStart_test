//
//  LoadingManager.swift
//  FocusStart_TestTask
//
//  Created by Андрей Шамин on 9/16/20.
//  Copyright © 2020 Андрей Шамин. All rights reserved.
//

import Foundation
import UIKit

struct LoadingManager {
    /// Декодирование decodedData в массив машин(cars), который возвращается в completion()
    static func decodeDataToCarsArray(_ decodedData: Data, completion:((_ cars:[Car])-> Void)) {
        if let decodedCars = try? JSONDecoder().decode([Car].self, from: decodedData) {
            completion(decodedCars)
        }
    }
}
