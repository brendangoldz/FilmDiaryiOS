//
//  FilmLoginView.swift
//  FilmLoginView
//
//  Created by Brendan Goldsmith on 9/4/21.
//

import SwiftUI

struct LoginView: View {
  @State private var userName: String = ""
    @State var alertShow:Bool = false;
    @State var alertStruct:UserAlert = UserAlert();
    @State var logInText: String = "Log In";
  let defaults = UserDefaults.standard;

  var body: some View {
    ZStack {
        if #available(iOS 15.0, *) {
            Color.mint
                .ignoresSafeArea(.all)
        } else {
            Color.gray
                .ignoresSafeArea(.all)
        }
      VStack {
        Text("Please log in")
          .font(.title2)
        TextField("User name", text: $userName)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .foregroundColor(Color.black)
        Button(logInText
) {
            let loginValidation = validateLogin(user: userName);
            if loginValidation == ""{
                API().login(usernameIn: userName)
                if defaults.string(forKey: "jwtToken") != nil {
                    logInText = userName;
                    alertStruct.title = "Success"
                    alertStruct.errorMsg = "Welcome, \(userName)"
                    self.alertShow.toggle()
                }
            } else {
                alertStruct.title = "Error";
                alertStruct.errorMsg = loginValidation;
                self.alertShow.toggle();
            }
        }.alert(isPresented: $alertShow, content: {
            Alert(title: Text(alertStruct.title), message: Text(alertStruct.errorMsg),
                  dismissButton:
                    Alert.Button.default(
                Text("Press ok here"), action: { print("Hello world!") }
            ))
        })
      }
      .frame(maxWidth: 320)
      .padding(.horizontal)
      
    }
  }
    func validateLogin(user: String) -> String {
        var msg:String = "";
        if user == "" {
            msg = "Please enter a valid username!";
        }
        return msg;
    }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}

class UserAlert {
    var title: String = ""
    var errorMsg: String = "";
}
