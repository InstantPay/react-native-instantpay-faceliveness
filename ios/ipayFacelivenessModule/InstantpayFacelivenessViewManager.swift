import UIKit
import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

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
  @Published var onErrorCallbackEvent: RCTBubblingEventBlock = {_ in }
  @Published var onCancelCallbackEvent: RCTBubblingEventBlock = {_ in }
  @Published var onSuccessCallbackEvent: RCTBubblingEventBlock = {_ in }
  
}

class InstantpayFacelivenessView : UIView {
  
  let LOGTAG = "LivenessLog*"
  
  var returningView: UIView?
  
  let dataStore: MyDataStore = .init()
  
  let defaultOptions : [String:Any] = [
    "debug" : false,
    "sessionId": "",
    "accessToken": "",
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
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    //logPrint("Loading")
    //dataStore.options = defaultOptions
    // Customize your view setup here
    //self.backgroundColor = .green // Example: Set background color to green
    
    // Configure Amplify
    do {
      //try Amplify.add(plugin: AWSCognitoAuthPlugin())
      //try Amplify.configure()
      
      //try Amplify.add(plugin: AWSCognitoAuthPlugin())
      //try Amplify.configure(with: .amplifyOutputs)
      //print("Amplify configured successfully")
    } catch {
      //print("Failed to configure Amplify \(error)")
    }
    
    let vc = UIHostingController(rootView: MainScreenView().environmentObject(dataStore))
    vc.view.frame = bounds
    self.addSubview(vc.view)
    self.returningView = vc.view
  }
  
  @objc var options: String = "" {
    didSet {
      
      guard let parseOptions = parseJSONString(jsonString: options) else {
        print("Error: Failed to parse options JSON string.")
        return
      }
      
      //logPrint("Get Options : \(parseOptions)")
      
      var defaultOptionsList = defaultOptions
      
      if(parseOptions.keys.contains("debug") && (parseOptions["debug"] as! Bool)){
        defaultOptionsList["debug"] = true
      }
      else{
        defaultOptionsList["debug"] = false
      }
      
      if(parseOptions.keys.contains("sessionId") && (parseOptions["sessionId"] as! String) != ""){
        defaultOptionsList["sessionId"] = parseOptions["sessionId"] as! String
      }
      
      if(parseOptions.keys.contains("accessToken") && (parseOptions["accessToken"] as! String) != ""){
        defaultOptionsList["accessToken"] = parseOptions["accessToken"] as! String
      }
      
      //Start Welcomse Screen Config
      var defaultWelcomeScreenConfig = defaultOptionsList["welcomeScreenConfig"] as? [String: Any]
      
      if(parseOptions.keys.contains("welcomeScreenConfig")){
        
        if let parseWelcomeConfigOptions = parseOptions["welcomeScreenConfig"] as? [String: Any]{
          
          if(parseWelcomeConfigOptions.keys.contains("hideScreen") && (parseWelcomeConfigOptions["hideScreen"] as! Bool)){
            
            defaultWelcomeScreenConfig?["hideScreen"] = true
          }
          else{
            
            defaultWelcomeScreenConfig?["hideScreen"] = false
            
            if(parseWelcomeConfigOptions.keys.contains("proceedButtonText") && (parseWelcomeConfigOptions["proceedButtonText"] as! String) != ""){
              defaultWelcomeScreenConfig?["proceedButtonText"] = parseWelcomeConfigOptions["proceedButtonText"] as! String
            }
            
            if(parseWelcomeConfigOptions.keys.contains("description") && (parseWelcomeConfigOptions["description"] as! String) != ""){
              defaultWelcomeScreenConfig?["description"] = parseWelcomeConfigOptions["description"] as! String
            }
            
            if(parseWelcomeConfigOptions.keys.contains("extraInstructionPoint") && (parseWelcomeConfigOptions["extraInstructionPoint"] as! Array<String>).count > 0){
              
              var instructionPointList = defaultWelcomeScreenConfig?["instructionPoint"] as! Array<String?>
              let extraInstructionPointList = parseWelcomeConfigOptions["extraInstructionPoint"] as! Array<String>
              
              instructionPointList += extraInstructionPointList
              
              defaultWelcomeScreenConfig?["instructionPoint"] = instructionPointList as! Array<String>
            }
          }
        }
      }
      
      defaultOptionsList["welcomeScreenConfig"] = defaultWelcomeScreenConfig
      //End Welcomse Screen Config
      
      //Start Verification Screen Config
      var defaultVerificationScreenConfig = defaultOptionsList["verificationScreenConfig"] as? [String: Any]
      
      if(parseOptions.keys.contains("verificationScreenConfig")){
        
        if let parseVerificationConfigOptions = parseOptions["verificationScreenConfig"] as? [String: Any]{
          
          if(parseVerificationConfigOptions.keys.contains("hideIntroScreen") && (parseVerificationConfigOptions["hideIntroScreen"] as! Bool)){
            
            defaultVerificationScreenConfig?["hideIntroScreen"] = true
          }
          else{
            defaultVerificationScreenConfig?["hideIntroScreen"] = false
          }
        }
      }
      
      defaultOptionsList["verificationScreenConfig"] = defaultVerificationScreenConfig
      //End Verification Screen Config
      
      //Start Config Screen Config
      var defaultConfig = defaultOptionsList["config"] as? [String: Any]
      
      if(parseOptions.keys.contains("config")){
        
        if let parseConfigOptions = parseOptions["config"] as? [String: Any]{
          
          if(parseConfigOptions.keys.contains("hideTitleBar") && (parseConfigOptions["hideTitleBar"] as! Bool)){
            defaultConfig?["hideTitleBar"] = true
          }
          else{
            defaultConfig?["hideTitleBar"] = false
          }
          
          if(parseConfigOptions.keys.contains("title") && (parseConfigOptions["title"] as! String) != ""){
            defaultConfig?["title"] = parseConfigOptions["title"] as! String
          }
          
          if(parseConfigOptions.keys.contains("titleColor") && (parseConfigOptions["titleColor"] as! String) != ""){
            defaultConfig?["titleColor"] = parseConfigOptions["titleColor"] as! String
          }
          
          if(parseConfigOptions.keys.contains("hideCloseButton") && (parseConfigOptions["hideCloseButton"] as! Bool)){
            defaultConfig?["hideCloseButton"] = true
          }
          else{
            defaultConfig?["hideCloseButton"] = false
          }
          
          //Color Config
          var defaultColorConfig = defaultConfig?["color"] as? [String: Any]
          
          if(parseConfigOptions.keys.contains("color")){
            
            if let parseColorConfigOptions = parseConfigOptions["color"] as? [String: Any]{
              
              if(parseColorConfigOptions.keys.contains("primaryLight") && (parseColorConfigOptions["primaryLight"] as! String) != ""){
                defaultColorConfig?["primaryLight"] = parseColorConfigOptions["primaryLight"] as! String
              }
              
              if(parseColorConfigOptions.keys.contains("onPrimaryLight") && (parseColorConfigOptions["onPrimaryLight"] as! String) != ""){
                defaultColorConfig?["onPrimaryLight"] = parseColorConfigOptions["onPrimaryLight"] as! String
              }
              
              if(parseColorConfigOptions.keys.contains("backgroundLight") && (parseColorConfigOptions["backgroundLight"] as! String) != ""){
                defaultColorConfig?["backgroundLight"] = parseColorConfigOptions["backgroundLight"] as! String
              }
              
              if(parseColorConfigOptions.keys.contains("onBackgroundLight") && (parseColorConfigOptions["onBackgroundLight"] as! String) != ""){
                defaultColorConfig?["onBackgroundLight"] = parseColorConfigOptions["onBackgroundLight"] as! String
              }
              
              if(parseColorConfigOptions.keys.contains("primaryDark") && (parseColorConfigOptions["primaryDark"] as! String) != ""){
                defaultColorConfig?["primaryDark"] = parseColorConfigOptions["primaryDark"] as! String
              }
              
              if(parseColorConfigOptions.keys.contains("onPrimaryDark") && (parseColorConfigOptions["onPrimaryDark"] as! String) != ""){
                defaultColorConfig?["onPrimaryDark"] = parseColorConfigOptions["onPrimaryDark"] as! String
              }
              
              if(parseColorConfigOptions.keys.contains("backgroundDark") && (parseColorConfigOptions["backgroundDark"] as! String) != ""){
                defaultColorConfig?["backgroundDark"] = parseColorConfigOptions["backgroundDark"] as! String
              }
              
              if(parseColorConfigOptions.keys.contains("onBackgroundDark") && (parseColorConfigOptions["onBackgroundDark"] as! String) != ""){
                defaultColorConfig?["onBackgroundDark"] = parseColorConfigOptions["onBackgroundDark"] as! String
              }
              
            }
          }
          
          defaultConfig?["color"] = defaultColorConfig
          //End Color Config
        }
      }
      
      defaultOptionsList["config"] = defaultConfig
      //End End Screen Config
      
      //logPrint("Default Options : \(defaultOptionsList)")
      
      dataStore.options = defaultOptionsList
    }
  }
  
  @objc var onErrorCallback: RCTBubblingEventBlock = {_ in} {
    didSet{
      dataStore.onErrorCallbackEvent = onErrorCallback
    }
  }
  
  @objc var onCancelCallback: RCTBubblingEventBlock = {_ in} {
    didSet{
      dataStore.onCancelCallbackEvent = onCancelCallback
    }
  }
  
  @objc var onSuccessCallback: RCTBubblingEventBlock = {_ in} {
    didSet{
      dataStore.onSuccessCallbackEvent = onSuccessCallback
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
      print("Failed to convert JSON string to data.")
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
