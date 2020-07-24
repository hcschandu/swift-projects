//
//  PasswordInputHandler.swift
//  Privacy Project
//
//  Created by Timothy/Ammar/Chandra on 10/17/19.
//  Copyright © 2019 PETS. All rights reserved.
//

import UIKit
import LocalAuthentication

//Needed?
extension String {
    enum ValidityType {
        case age
        case email
        case password
    }
    
    enum Regex: String {
        case age = "[0-9]{2,2}"
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case password = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{6,25}"
        
        func isValid(_ validityType: ValidityType) -> Bool {
            let format = "SELF MATCHES %@"
            var regex = ""
            switch validityType {
            case .age:
                regex = Regex.age.rawValue
            case .email:
                regex = Regex.email.rawValue
            case .password:
                regex = Regex.password.rawValue
            }
            return NSPredicate(format: format, regex).evaluate(with: self)
        }
    }
}

class PasswordInputHandler: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var accessCodeTextField: UITextField!
    @IBOutlet weak var enteredPasswordTextField: UITextField!
    var correctPassword = "private"
    var decoyPassword = "decoy"
    
    //Conditional statement depending on password input (go to main menu, decoy, or not proceed)
    @IBAction func checkPassword(_ sender: Any) {
        let passwordEntered = enteredPasswordTextField.text;
        if (passwordEntered?.isEmpty ?? false) {
            displayMyAlertMessage(userMessage: "Please enter a password.");
            return;
        }
        else if(passwordEntered == decoyPassword){
            performSegue(withIdentifier: "Decoy", sender: self)
        }
        else if(passwordEntered == correctPassword){
            performSegue(withIdentifier: "Private", sender: self)
        }
        else {
            displayMyAlertMessage(userMessage: "Please enter the correct password.");
            return;
        }
    }
    
    //Display alert message
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle:UIAlertController.Style.alert);
        let okAction = UIAlertAction(title:"OK" , style: UIAlertAction.Style.default, handler: nil);
        myAlert.addAction(okAction);
        self.present(myAlert, animated:true, completion:nil);
    }
    
    //Touch ID setup
    @IBAction func touchID(_ sender: Any) {
        let context : LAContext = LAContext();
        if(context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Message - Touch ID") { (good, error) in
            if(good){
                print("Success.")
                self.performSegue(withIdentifier: "Private", sender: self)
            }
            else{
                print("Try Again.")
            }
        }}
    }
    
    //Face ID set up
    @IBAction func faceID(_ sender: Any) {
        let context : LAContext = LAContext();
        if(context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Message - Face ID") { (good, error) in
            if(good){
                print("Success.")
                self.performSegue(withIdentifier: "Private", sender: self)
            }
            else{
                print("Try Again")
            }
        }}
    }
    
    //Executed upon view controller being segued into
    override func viewDidLoad() {
        super.viewDidLoad()
        enteredPasswordTextField.delegate = self;
        // Do any additional setup after loading the view.
    }
    
    //Handle exiting text field on phone
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
