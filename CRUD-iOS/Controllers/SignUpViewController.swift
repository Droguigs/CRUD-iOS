//
//  SignUpViewController.swift
//  CRUD-iOS
//
//  Created by Douglas Schiavi on 09/07/20.
//  Copyright © 2020 Douglas Schiavi. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var cpf: UITextField!
    @IBOutlet weak var birthDate: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    let cache = ClientCache()
    
    let datePicker = UIDatePicker()
    let genderPicker = UIPickerView()
    
    let genderPickerData = ["", "Masculino", "Feminino"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePickers()
        setupGestureAndKeyboard()
    }
    
    func setupGestureAndKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelDatePicker))
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.keyboardNotification(notification:)),
        name: UIResponder.keyboardWillChangeFrameNotification,
        object: nil)
        self.view.addGestureRecognizer(tap)
    }
    
    func configurePickers() {
        
        datePicker.locale = .init(identifier: "pt_BR")
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        birthDate.inputAccessoryView = toolbar
        birthDate.inputView = datePicker
        
        let defaultToolbar = UIToolbar()
        defaultToolbar.sizeToFit()
        let defaultDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));

        defaultToolbar.setItems([cancelButton,spaceButton,defaultDoneButton], animated: false)
        
        genderPicker.delegate = self
        gender.inputAccessoryView = defaultToolbar
        gender.inputView = genderPicker
        
        cpf.inputAccessoryView = defaultToolbar
        telephone.inputAccessoryView = defaultToolbar
        name.inputAccessoryView = defaultToolbar
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getUserTableName(client: Client) -> String {
        let now = Date()
        let birthday: Date = client.birthDate
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        
        return client.name + "- \(age)"
        
    }
    
    func showToast(message : String, font: UIFont, color: UIColor) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 175, y: self.view.frame.size.height-100, width: 350, height: 35))
        toastLabel.backgroundColor = color.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 8.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    @IBAction func save(_ sender: Any) {
        
        if let name = name.text,
            let cpf = cpf.text,
            let tel = telephone.text,
            let gender = gender.text,
            let date = birthDate.text {
            
            if name != "",
                cpf != "",
                tel != "",
                gender != "",
                date != "" {
                
                if cache.allClients(cpf: cpf).isEmpty {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    let birthDate = formatter.date(from: date)
                    
                    let now = Date()
                    let birthday: Date = birthDate ?? Date()
                    let calendar = Calendar.current

                    let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
                    let age = ageComponents.year!
                    
                    let client = Client(name: name,
                                        telephone: tel,
                                        cpf: cpf,
                                        birthDate: birthday,
                                        gender: gender,
                                        tableText: name + "- \(age)")
                    self.cache.add(client: client)
                    
                    showToast(message: "Cliente cadastrado com sucesso", font: .systemFont(ofSize: 15), color: .systemGreen)
                } else {
                    showToast(message: "Cliente ja cadastrado", font: .systemFont(ofSize: 15), color: .systemRed)
                }
            } else {
                showToast(message: "Favor preencher todos os campos", font: .systemFont(ofSize: 15), color: .systemRed)
            }
        } else {
            showToast(message: "Favor preencher todos os campos", font: .systemFont(ofSize: 15), color: .systemRed)
        }
    }
    
    // MARK: Objc funcs
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }

    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        birthDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func done(){
        self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
}

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        3
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     return genderPickerData[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gender.text = genderPickerData[row]
    }
    
}
