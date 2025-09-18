import SwiftUI

class MyDataStore: ObservableObject {
    @Published var options: [String: Any] = [:]
    @Published var onErrorCallbackEvent: (([String: Any]) -> Void) = {_ in }
    @Published var onCancelCallbackEvent: (([String: Any]) -> Void) = {_ in }
    @Published var onSuccessCallbackEvent: (([String: Any]) -> Void) = {_ in }
}

@objc public class InstantpayFacelivenessViewManager: NSObject {
    
    private let hostingController: UIHostingController<AnyView>?
    
    private let LOGTAG = "LivenessLog*"
    
    //let dataStore: MyDataStore = .init()
    private let dataStore: MyDataStore
    
    @objc public var responseCallback: ((String,[String: Any]) -> Void)?
    
    @objc public override init() {
        
        dataStore = MyDataStore()

        hostingController = UIHostingController(
            rootView: AnyView(MainScreenView().environmentObject(dataStore))
        )
        
        super.init()
        
        logPrint("Loading SwiftUI View from Objective-C init function")
        
        dataStore.onCancelCallbackEvent = { dict in
            if let message = dict["message"] as? String {
                print("Callback received: \(message)")
                self.responseCallback?("CANCELED",dict)
            }
        }
    }
    
    @objc public func getView() -> UIView {
        return hostingController!.view
    }
    
    @objc public func updateOptions(newOptions: String) {
        
        logPrint("Get Options : \(newOptions)")
        
        //dataStore.options = newOptions
        dataStore.options = ["name" : "sdfdsfdsfdg"]
    }
    
    
    func logPrint(_ value:String){
        print("\(LOGTAG)=> \(value) ")
    }
    
}
