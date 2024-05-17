
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    var body: some View {
        NavigationView {
            List {
                NavigationLink("Light Mode", destination: LightModeView())
                NavigationLink("Policy", destination: Text("Policy Settings"))
                NavigationLink("About App", destination: Text("About App"))
                Button("Sign Out") {
                    authViewModel.signOut()
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Settings")
        }
    }
}



