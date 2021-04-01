//
//  SignUpViewController.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 5/1/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBAction func registerAccount(sender: UIButton) {
        
        // 輸入驗證
        guard let name = nameTextField.text, name != "",let email = emailTextField.text, email != "",let password = passwordTextField.text, password != "" else {
            
            let alert = UIAlertController(title: "Registration Error", message: "Please make sure you provide your name, email address and password to complete the registration", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Firebase 註冊帳號
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            (user, error) in
            
            if let error = error {
                let alert = UIAlertController(title: "Registration error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            //儲存使用者名稱
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest(){
                
                changeRequest.displayName = name
                changeRequest.commitChanges(completion: {
                    (error) in
                    if let error = error {
                        print("Failed to change the display name: \(error.localizedDescription)")
                    }
                })
            }
            
            // 移除鍵盤
            self.view.endEditing(true)
            
            Auth.auth().currentUser?.sendEmailVerification(completion: {
                (error) in
                print("Failed to send verification email")
            })
            
            let alert = UIAlertController(title: "Email Verification", message: "We've just sent a confirmation email to your email address. Please check your inbox and click the verification link in that email to complete the sign up.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                (action) in
                
                // 解除目前試圖控制器
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            // 呈現主視圖
//            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView"){
//                UIApplication.shared.keyWindow?.rootViewController = viewController
//                self.dismiss(animated: true, completion: nil)
//            }
            
        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Sign Up"
        nameTextField.becomeFirstResponder()
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
