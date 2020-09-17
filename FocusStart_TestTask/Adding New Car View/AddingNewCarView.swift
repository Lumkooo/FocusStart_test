//
//  AddingNewCarView.swift
//  FocusStart_TestTask
//
//  Created by Андрей Шамин on 9/15/20.
//  Copyright © 2020 Андрей Шамин. All rights reserved.
//

import UIKit

class AddingNewCarView: UIView {
    
    @IBOutlet var addCarButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var carMarkTextField: UITextField!
    @IBOutlet var carModelTextField: UITextField!
    @IBOutlet var mainViewWidth: NSLayoutConstraint!
    @IBOutlet var mainViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var mainView: UIView!
    @IBOutlet var carBodyTypeButton: UIButton!
    @IBOutlet var carYearTextField: UITextField!
    static let ITEM_NIB = "AddingNewCarView"
    var chosenCarBodyType:String?
    var delegate: AddNewCarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed(AddingNewCarView.ITEM_NIB , owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        carMarkTextField.delegate = self
        carModelTextField.delegate = self
        carYearTextField.delegate = self
    }
    
    func editingTheCreatedCar(car:Car?){
        if let car = car{
            self.carMarkTextField.text = car.mark
            self.carModelTextField.text = car.model
            self.carYearTextField.text = car.year
            self.carBodyTypeButton.setTitle(car.carBodyType.rawValue, for: .normal)
            chosenCarBodyType = car.carBodyType.rawValue
            addCarButton.setTitle("Сохранить", for: .normal)
        }
    }
        
    func changeCarBodyType() {
        let chooseCarBodyType = ChooseCarBodyType(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height))
        chooseCarBodyType.delegate = self
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: {
            chooseCarBodyType.contentView.backgroundColor = UIColor(white: 1, alpha: 0.75)
            chooseCarBodyType.mainView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
        contentView.addSubview(chooseCarBodyType)
    }

    @IBAction func changeCarBodyTypeAction(_ sender: Any) {
        changeCarBodyType ()
    }
    
    fileprivate func closeAddNewCarViewAnimated(completion:@escaping (()->Void)) {
        UIView.animate(withDuration: 0.4) {
            self.mainView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.contentView.backgroundColor = UIColor(white: 1, alpha: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            completion()
            self.removeFromSuperview()
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        closeAddNewCarViewAnimated {
            self.delegate?.cancelTapped()
        }
    }
    
    fileprivate func requiredViewShake(_ view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(translationX: 5, y: 0)
        }) { (action) in
            UIView.animate(withDuration: 0.1, animations: {
                view.transform = CGAffineTransform(translationX: -5, y: 0)
            }) { (action) in
                UIView.animate(withDuration: 0.1, animations: {
                    view.transform = CGAffineTransform(translationX: 5, y: 0)
                }) { (action) in
                    UIView.animate(withDuration: 0.1, animations: {
                        view.transform = CGAffineTransform(translationX: 0, y: 0)
                    })
                }
            }
        }
    }
    
    fileprivate func textFieldIsRequiredToFill(textField: UITextField) {
        let redColor = UIColor.red
        let attributedStringColor = [NSAttributedString.Key.foregroundColor : redColor];
        let attributedString = NSAttributedString(string: "Это поле обязательно для заполнения", attributes: attributedStringColor)
        textField.attributedPlaceholder = attributedString
        requiredViewShake(textField)
    }
    
    fileprivate func buttonsIsRequiredToFill(button:UIButton) {
        button.setTitle("Необходимо выбрать", for: .normal)
        requiredViewShake(button)
    }
    
    @IBAction func addCarAction(_ sender: Any) {
        let carMark = carMarkTextField.text
        let carModel = carModelTextField.text
        let year = carYearTextField.text
        let carBodyType = self.chosenCarBodyType
        if carMark == nil || carMark == ""{
            textFieldIsRequiredToFill(textField: carMarkTextField)
        }
        if carModel == nil || carModel == ""{
            textFieldIsRequiredToFill(textField: carModelTextField)
        }
        if year == nil || year == ""{
            textFieldIsRequiredToFill(textField: carYearTextField)
        }
        if carBodyType == nil{
            buttonsIsRequiredToFill(button: carBodyTypeButton)
        }
        if let carModel = carModel, carModel != "", carMark != "", let carMark = carMark, year != "" , let year = year, let carBodyType = carBodyType{
            closeAddNewCarViewAnimated {
                self.delegate?.addTapped(carMark: carMark, carModel: carModel, carBodyType: CarBodyType(rawValue: carBodyType)!, carYear: year)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension AddingNewCarView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == carMarkTextField {
            carMarkTextField.resignFirstResponder()
            carModelTextField.becomeFirstResponder()
        } else if textField == carModelTextField {
            carModelTextField.resignFirstResponder()
            carYearTextField.becomeFirstResponder()
        }  else if textField == carYearTextField {
            carYearTextField.resignFirstResponder()
            changeCarBodyType ()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == carYearTextField {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        } else {
            return true
        }
    }
}

// MARK: - ChooseCarBodyTypeDelegate
extension AddingNewCarView: ChooseCarBodyTypeDelegate {
    func cancelTapped() {
        self.carBodyTypeButton.setTitle("Выбрать", for: .normal)
        self.chosenCarBodyType = nil
    }
    
    func doneTapped(chosenCarBodyType: String) {
        self.carBodyTypeButton.setTitle(chosenCarBodyType, for: .normal)
        self.chosenCarBodyType = chosenCarBodyType
    }
}
