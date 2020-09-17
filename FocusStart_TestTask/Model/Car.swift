//
//  Car.swift
//  FocusStart_TestTask
//
//  Created by Андрей Шамин on 9/14/20.
//  Copyright © 2020 Андрей Шамин. All rights reserved.
//

import Foundation

struct Car:Codable {
//    Год выпуска, производителя, модель, тип кузова.
    var id:Int
    var mark:String
    var model:String
    var carBodyType:CarBodyType
    var year:String
}

enum CarBodyType:String, CaseIterable, Codable {
    case sedan = "Седан"
    case hatchback = "Хэтчбек"
    case universal = "Универсал"
    case liftback = "Лифтбэк"
    case coupe = "Купе"
    case cabrio = "Кабриолет"
    case rodster = "Родстер"
    case stretch = "Стретч"
    case targa = "Тарга"
    case suv = "Внедорожник"
    case crossover = "Кроссовер"
    case pickup = "Пикап"
    case van = "Фургон"
    case minivan = "Минивэн"
}
