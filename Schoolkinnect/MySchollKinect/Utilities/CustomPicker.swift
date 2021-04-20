//
//  CustomPicker.swift
//  Route
//
//  Created by DECODER on 04/08/18.
//  Copyright © 2018 VirtualHeight It Services PVT LTD. All rights reserved.
//

import UIKit

protocol PickerDelegate:class {
    func PickerView(pickerView:UIPickerView,didSelect button:UIButton)
}

class CustomPicker: UIView,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnOk: UIButton!
    @IBOutlet var Picker: UIPickerView!
    @IBOutlet weak var DatePickerView: UIDatePicker!
    
    var DataSource = [String]()
    weak var delegate:PickerDelegate?

    override func awakeFromNib() {
        Picker.delegate = self
        Picker.dataSource = self
        btnCancel.addTarget(self, action: #selector(Cancel(sender:)), for: .touchUpInside)
        btnOk.addTarget(self, action: #selector(ButtonClicked(sender:)), for: .touchUpInside)

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DataSource[row]
    }
    
    func reloadData()
    {
        Picker.reloadAllComponents()
    }
    
    @objc private func ButtonClicked(sender:UIButton)
    {
        delegate?.PickerView(pickerView: self.Picker, didSelect: sender)
    }

    @objc func Cancel(sender:UIButton)
    {
        delegate?.PickerView(pickerView: self.Picker, didSelect: sender)
    }

}
