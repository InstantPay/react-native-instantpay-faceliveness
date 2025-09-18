import SwiftUI

public struct MainScreenView: View {
    
    @EnvironmentObject var dataStore: MyDataStore
    
    public var body: some View {
        
        let optionsList = dataStore.options
        
        Text("\(optionsList["name"] as! String)")
        
        Spacer()
        
        Image(systemName: "xmark")
            .font(Font.system(size: 22, weight: .bold))
            .onTapGesture {
                print("Fire")
                dataStore.onCancelCallbackEvent(["message" : "Cancel by User on Verification Screen"])
            }
    }
}
