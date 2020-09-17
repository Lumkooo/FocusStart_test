//
//  OneCarViewController.swift
//  FocusStart_TestTask
//
//  Created by Андрей Шамин on 9/15/20.
//  Copyright © 2020 Андрей Шамин. All rights reserved.
//

import UIKit

class OneCarViewController: UIViewController {

    var car:Car?
    var cars:[Car]?
    @IBOutlet var carYearLabel: UILabel!
    @IBOutlet var carBodyTypeLabel: UILabel!
    var carListViewController:CarListViewController?
    
    fileprivate func showInfoAbout(_ car: Car) {
        self.title = car.mark + " " + car.model
        carYearLabel.text = "Год производства: \n" + car.year
        carBodyTypeLabel.text = "Тип кузова: \n" + car.carBodyType.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let car = car{
            showInfoAbout(car)
        }
    }
    
    @IBAction func changeThisCarAction(_ sender: Any) {
        navigationController?.navigationBar.isUserInteractionEnabled = false
        let changeThisCarView = AddingNewCarView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        changeThisCarView.mainViewWidth.constant = view.frame.width * 0.85
        changeThisCarView.mainViewLeadingConstraint.constant = -view.frame.width * 0.85
        changeThisCarView.delegate = self
        changeThisCarView.editingTheCreatedCar(car: car)
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            changeThisCarView.contentView.backgroundColor = UIColor(white: 1, alpha: 0.75)
            changeThisCarView.mainView.transform = CGAffineTransform(translationX: self.view.frame.width/2 + changeThisCarView.mainView.frame.width/2+40, y: 0)
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.2) {
                changeThisCarView.mainView.transform = CGAffineTransform(translationX: self.view.frame.width/2 + changeThisCarView.mainView.frame.width/2, y: 0)
            }
        }
        view.addSubview(changeThisCarView)
    }
}

// MARK: - AddNewCarDelegate
extension OneCarViewController: AddNewCarDelegate {
    
    func addTapped(carMark: String, carModel: String, carBodyType: CarBodyType, carYear: String) {
        navigationController?.navigationBar.isUserInteractionEnabled = true
        
        guard let _ = self.cars else { return }
        let newCar = Car(id: self.car!.id, mark: carMark, model: carModel, carBodyType: carBodyType, year: carYear)
        showInfoAbout(newCar)
        if let row = self.cars!.firstIndex(where:{$0.id == self.car!.id}) {
            self.cars![row] = newCar
        }
        SaveManager.saveToUserDefaults(self.cars!)
        carListViewController?.refreshCarsAfterEditing(cars: self.cars!)
    }
    
    func cancelTapped() {
        navigationController?.navigationBar.isUserInteractionEnabled = true
    }
}
