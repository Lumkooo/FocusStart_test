//
//  ViewController.swift
//  FocusStart_TestTask
//
//  Created by Андрей Шамин on 9/14/20.
//  Copyright © 2020 Андрей Шамин. All rights reserved.
//

import UIKit

class CarListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var cars:[Car] = []
    var chosenCar:Car?
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    fileprivate func addThreeCarToUserDefaults() {
        let car = Car(id:0,mark: "Mercedes", model: "C-Class", carBodyType: .coupe, year: "2020")
        let secondCar = Car(id:1,mark: "Audi", model: "A4", carBodyType: .sedan, year: "2019")
        let thirdCar = Car(id:2,mark: "Mazda", model: "6", carBodyType: .sedan, year: "2019")
        cars.append(car)
        cars.append(secondCar)
        cars.append(thirdCar)
        SaveManager.saveToUserDefaults(cars)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.hideKeyboardWhenTappedAround()
        if let decodedData = UserDefaults.standard.object(forKey: "Car") as? Data {
            LoadingManager.decodeDataToCarsArray(decodedData) { (cars) in
                self.cars = cars
                self.tableView.reloadData()
            }
        } else {
            addThreeCarToUserDefaults()
        }
    }
    
    func refreshCarsAfterEditing(cars:[Car]?){
        if let cars = cars{
            self.cars = cars
            self.tableView.reloadData()
        }
    }

    @IBAction func addCarAction(_ sender: Any) {
        navigationController?.navigationBar.isUserInteractionEnabled = false
        let addingNewCarView = AddingNewCarView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        addingNewCarView.mainViewWidth.constant = view.frame.width * 0.85
        addingNewCarView.mainViewLeadingConstraint.constant = -view.frame.width * 0.85
        addingNewCarView.delegate = self
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            addingNewCarView.contentView.backgroundColor = UIColor(white: 1, alpha: 0.75)
            addingNewCarView.mainView.transform = CGAffineTransform(translationX: self.view.frame.width/2 + addingNewCarView.mainView.frame.width/2+40, y: 0)
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.2) {
                addingNewCarView.mainView.transform = CGAffineTransform(translationX: self.view.frame.width/2 + addingNewCarView.mainView.frame.width/2, y: 0)
            }
        }
        view.addSubview(addingNewCarView)
    }
    
    @IBAction func editListAction(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CarListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarListTableViewCell", for: indexPath) as! CarListTableViewCell
        let car = cars[indexPath.row]
        cell.carMarkLabel.text = car.mark
        cell.carModelLabel.text = car.model
        cell.carYearLabel.text = car.year
        cell.carBodyType.text = car.carBodyType.rawValue
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOneCarSegueID"{
            (segue.destination as! OneCarViewController).car = chosenCar
            (segue.destination as! OneCarViewController).cars = cars
            (segue.destination as! OneCarViewController).carListViewController = self
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenCar = cars[indexPath.row]
        
        performSegue(withIdentifier: "showOneCarSegueID", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.cars.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            SaveManager.saveToUserDefaults(cars)
        }
    }
}

// MARK: - UITableViewDataSource, AddNewCarDelegate
extension CarListViewController: AddNewCarDelegate {
    
    func addTapped(carMark: String, carModel: String, carBodyType: CarBodyType, carYear: String) {
        navigationController?.navigationBar.isUserInteractionEnabled = true
        var newCarID:Int = 0
        for (index, element) in cars.enumerated() {
            if index == cars.endIndex-1 {
                newCarID = element.id + 1
            }
        }
        let car = Car(id: newCarID, mark: carMark, model: carModel, carBodyType: carBodyType, year: carYear)
        cars.append(car)
        SaveManager.saveToUserDefaults(cars)
        tableView.reloadData()
    }
    
    func cancelTapped() {
        navigationController?.navigationBar.isUserInteractionEnabled = true
    }
}

// MARK: - UIViewController extension: hideKeyboardWhenTappedAround added
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
