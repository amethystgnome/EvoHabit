import SwiftUI
import Combine

struct AuthenticationView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var isLogin = true
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            if isLogin {
                Text("Login")
                    .font(.largeTitle)
                    .padding()
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Login") {
                    print("Login button pressed")
                    authViewModel.login(email: email, password: password)
                }
                .padding()
            } else {
                Text("Sign Up")
                    .font(.largeTitle)
                    .padding()
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Sign Up") {
                    print("Sign Up button pressed")
                    authViewModel.signUp(name: name, email: email, password: password)
                }
                .padding()
            }
            Button(isLogin ? "Switch to Sign Up" : "Switch to Login") {
                isLogin.toggle()
            }
            .padding()
        }
        .padding()
        .background(Color.white)
        .onAppear {
            print("AuthenticationView appeared")
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(AuthenticationViewModel())
    }
}
