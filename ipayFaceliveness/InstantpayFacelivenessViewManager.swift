import UIKit
import SwiftUI

@objc(InstantpayFacelivenessViewManager)
class InstantpayFacelivenessViewManager: RCTViewManager {

      override func view() -> (InstantpayFacelivenessView) {
          return InstantpayFacelivenessView()
      }

      @objc override static func requiresMainQueueSetup() -> Bool {
        return true
      }
}

class MyDataStore: ObservableObject {
    @Published var options: [String: Any] = [:]
    @Published var onErrorCallback: RCTBubblingEventBlock = {_ in }
}

class InstantpayFacelivenessView : UIView {
    
    let LOGTAG = "LivenessLog*"
    
    var returningView: UIView?
    let dataStore: MyDataStore = .init()
    
    let defaultOptions : [String:Any] = [
        "debug" : false,
        "sessionId": "",
        "title" : "Liveness Check",
        "welcomeScreenConfig" : [
            "hideScreen" : false,
            "proceedButtonText" :  "Proceed Liveness Check",
            "description" : "You will go through a face verification process to prove that you are a real person.",
            "instructionPoint" : [
                "When an oval appears, fill the oval with your face within 7 seconds.",
                "Maximize your screen's brightness.",
                "Make sure your face is not covered with sunglasses or a mask.",
                "Move to a well-lit place that is not in direct sunlight.",
                "This check displays colored lights. Use caution if you are photosensitive."
            ],
            "extraInstructionPoint" : []
        ],
        "verificationScreenConfig" : [
            "hideIntroScreen" : false
        ],
        "config" : [
            "hideTitleBar" : false,
            "title" : "Liveness Check",
            "titleColor" : "#000000",
            "hideCloseButton" : false,
            "color" : [
                "primaryLight" : "#7DD6E8",
                "onPrimaryLight" : "#FFFFFF",
                "backgroundLight" : "#FFFFFF",
                "onBackgroundLight" : "#000000",
                "primaryDark" : "#047D95",
                "onPrimaryDark" : "#FAFAFA",
                "backgroundDark" : "#FAFAFA",
                "onBackgroundDark" : "#FFFFFF",
            ]
        ]
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let vc = UIHostingController(rootView: MainScreenView().environmentObject(dataStore))
        vc.view.frame = bounds
        self.addSubview(vc.view)
        self.returningView = vc.view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }
    
    @objc var options: String = "" {
        didSet {
            
            guard let parseOptions = parseJSONString(jsonString: options) else {
                print("Error: Failed to parse options JSON string.")
                return
            }
            
            logPrint("Get Options : \(parseOptions)")
            
            var defaultOptionsList = defaultOptions
            
            logPrint("Default Options : \(defaultOptionsList)")
            
            if(parseOptions.keys.contains("title") && (parseOptions["title"] as! String) != ""){
                
                defaultOptionsList["title"] = parseOptions["title"]
            }
            else{
                
                logPrint("dfdsfsdfsdfdsf")
                
                //newOptionsList["title"] = defaultOptionsList["title"]
            }
            
            dataStore.options = defaultOptionsList
        }
    }
    
    @objc var onErrorCallback: RCTBubblingEventBlock = {_ in} {
        didSet{
          dataStore.onErrorCallback = onErrorCallback
        }
    }

    func hexStringToUIColor(hexColor: String) -> UIColor {
      
        let stringScanner = Scanner(string: hexColor)

        if(hexColor.hasPrefix("#")) {
            stringScanner.scanLocation = 1
        }
        var color: UInt32 = 0
        stringScanner.scanHexInt32(&color)

        let r = CGFloat(Int(color >> 16) & 0x000000FF)
        let g = CGFloat(Int(color >> 8) & 0x000000FF)
        let b = CGFloat(Int(color) & 0x000000FF)

        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
    
    func convertToDictionary(from jsonString: String) -> [String: Any]? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return json
            }
        } catch {
            print("Error converting JSON string to dictionary: \(error.localizedDescription)")
        }

        return nil
    }
    
    func parseJSONString(jsonString: String) -> [String: Any]? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        do {
            // Deserialize JSON data into a dictionary
            if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return jsonDictionary
            }
        } catch {
            print("Error parsing JSON string:", error.localizedDescription)
        }
        return nil
    }
    
    func logPrint(_ value:String){
        print("\(LOGTAG)=> \(value) ")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.returningView?.frame = bounds
    }

}
