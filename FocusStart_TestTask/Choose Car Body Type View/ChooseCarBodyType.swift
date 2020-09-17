//
//  ChooseCarBodyType.swift
//  FocusStart_TestTask
//
//  Created by Андрей Шамин on 9/15/20.
//  Copyright © 2020 Андрей Шамин. All rights reserved.
//

import UIKit

class ChooseCarBodyType: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var pickerView: UIPickerView!
    static let ITEM_NIB = "ChooseCarBodyType"
    var carBodyTypes:[String] = []
    var chosenCarBodyType:String?
    var delegate: ChooseCarBodyTypeDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed(ChooseCarBodyType.ITEM_NIB , owner: self, options: nil)
        addSubview(contentView)
        pickerView.delegate = self
        pickerView.dataSource = self
        for bodyTypeCase in CarBodyType.allCases {
            carBodyTypes.append(bodyTypeCase.rawValue)
        }
        contentView.frame = self.bounds
        mainView.transform = CGAffineTransform(translationX: 0, y: mainView.frame.height)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    fileprivate func closeChooseCarBodyTypeView(closure: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
            self.contentView.backgroundColor = UIColor(white: 1, alpha: 0)
            self.mainView.transform = CGAffineTransform(translationX: 0, y: self.mainView.frame.height)
        }) { (action) in
            closure()
            self.removeFromSuperview()
        }
    }

    @IBAction func acceptAction(_ sender: Any) {
        closeChooseCarBodyTypeView {
            if let chosenCarBodyType = self.chosenCarBodyType{
                self.delegate?.doneTapped(chosenCarBodyType: chosenCarBodyType)
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        closeChooseCarBodyTypeView {
            self.delegate?.cancelTapped()
        }
    }
}

extension ChooseCarBodyType: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return carBodyTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        attributedString = NSAttributedString(string: carBodyTypes[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenCarBodyType = carBodyTypes[row]
    }
}
