//
//  ContentView.swift
//  ipayFaceliveness
//
//  Created by Dhananjay Kumar on 10/06/24.
//
//Please uncomment when want to use

/*import SwiftUI
import FaceLiveness
import Amplify
import AWSClientRuntime
import protocol AWSPluginsCore.AWSCredentialsProvider
import protocol AWSPluginsCore.AWSCredentials
import protocol AWSPluginsCore.AWSTemporaryCredentials


public struct MainScreenView: View {
  
  //@Binding var options: [String: Any]
  
  @SwiftUI.Environment(\.colorScheme) var colorScheme
  
  @EnvironmentObject var dataStore: MyDataStore
  
  @State private var isPresentingLiveness = true
  
  @State private var hideWelcomeScreen = false
  
  @State private var hideVerificationScreen = true
  
  @State private var currentScreen = "WELCOME" //WELCOME,VERIFICATION
  
  @State private var credentialsProvider: AWSCredentialsProvider? = nil
  
  public var body: some View {
    
    let optionsList = dataStore.options
    
    let configOptions = optionsList["config"] as? [String: Any]
    
    let welcomeScreenOptions = optionsList["welcomeScreenConfig"] as? [String: Any]
    
    let verificationScreenOptions = optionsList["verificationScreenConfig"] as? [String: Any]
    
    let colorConfigOptions = configOptions?["color"] as? [String: Any]
    
    VStack {
      
      /**Title Layout**/
      if (!(configOptions?["hideTitleBar"] as! Bool)) {
        
        HStack{
          
          Text("\(configOptions?["title"] as! String)")
            .font(Font.system(size:26,design: .default))
            .fontWeight(.semibold)
            .apply{
              if #available(iOS 17.0, *) {
                $0.foregroundStyle(Color(hex: (configOptions?["titleColor"] as! String)))
              } else {
                $0.foregroundColor(Color(hex: (configOptions?["titleColor"] as! String)))
              }
            }
          
          Spacer()
          
          if (!(configOptions?["hideCloseButton"] as! Bool)) {
            
            Image(systemName: "xmark")
              .font(Font.system(size: 22, weight: .bold))
              .apply{
                if #available(iOS 17.0, *) {
                  $0.foregroundStyle(Color(hex: (configOptions?["titleColor"] as! String)))
                } else {
                  $0.foregroundColor(Color(hex: (configOptions?["titleColor"] as! String)))
                }
              }
              .onTapGesture {
                
                if(currentScreen == "VERIFICATION"){
                  
                  if ((welcomeScreenOptions?["hideScreen"] as! Bool ) ) {
                    dataStore.onCancelCallbackEvent(["message" : "Cancel by User on Verification Screen"])
                  }
                  else{
                    hideVerificationScreen = true
                    hideWelcomeScreen = false
                    currentScreen = "WELCOME"
                  }
                }
                else if(currentScreen == "WELCOME"){
                  hideVerificationScreen = true
                  hideWelcomeScreen = false
                  dataStore.onCancelCallbackEvent(["message" : "Cancel by User"])
                }
                else{
                  dataStore.onCancelCallbackEvent(["message" : "Cancel by User"])
                }
              }
          }
          
        }
        .background(colorScheme == .dark ? Color(hex: (colorConfigOptions!["backgroundDark"] as! String)) : Color(hex: (colorConfigOptions!["backgroundLight"] as! String)) )
        .frame(
          minWidth: 0,
          maxWidth: .infinity,
          alignment: .topLeading
        ).padding(.bottom, 5)
      }
      
      /**Close Title Layout**/
      
      ZStack(alignment: .bottom) {
        
        /**Welcome  Screen Layout**/
        VStack {
          if (!hideWelcomeScreen) {
            VStack{
              
              ScrollView{
                
                VStack(alignment: .leading){
                  
                  Text("\(welcomeScreenOptions?["description"] as! String)")
                    .padding(.bottom, 10)
                    .apply{
                      if #available(iOS 17.0, *) {
                        $0.foregroundStyle(colorScheme == .dark ? Color(hex: (colorConfigOptions!["onBackgroundDark"] as! String), opacity: 0.5) : Color(hex: (colorConfigOptions!["onBackgroundLight"] as! String), opacity: 0.5))
                      } else {
                        $0.foregroundColor(colorScheme == .dark ? Color(hex: (colorConfigOptions!["onBackgroundDark"] as! String), opacity: 0.5) : Color(hex: (colorConfigOptions!["onBackgroundLight"] as! String), opacity: 0.5))
                      }
                    }
                  
                  Text("Follow the instructions to complete the check:")
                    .padding(.bottom, 3)
                    .apply{
                      if #available(iOS 17.0, *) {
                        $0.foregroundStyle(colorScheme == .dark ? Color(hex: (colorConfigOptions!["onBackgroundDark"] as! String)) : Color(hex: (colorConfigOptions!["onBackgroundLight"] as! String)))
                      } else {
                        $0.foregroundColor(colorScheme == .dark ? Color(hex: (colorConfigOptions!["onBackgroundDark"] as! String)) : Color(hex: (colorConfigOptions!["onBackgroundLight"] as! String)))
                      }
                    }
                  
                  HStack{
                    
                    if #available(iOS 15.0, *) {
                      AsyncImage(url: URL(string: "https://static.instantpay.in/assets/idv/good_fit.png")) { image in
                        image.resizable()
                          .scaledToFit()
                      } placeholder: {
                        ProgressView().frame(width: 150, height: 200)
                      }
                      //.frame(width: 128, height: 128)
                      //.clipShape(.rect(cornerRadius: 25))
                    } else {
                      // Fallback on earlier versions
                    }
                    
                    if #available(iOS 15.0, *) {
                      AsyncImage(url: URL(string: "https://static.instantpay.in/assets/idv/too_far.png")) { image in
                        image.resizable()
                          .scaledToFit()
                      } placeholder: {
                        ProgressView().frame(width: 150, height: 200)
                      }
                      //.frame(width: 128, height: 128)
                      //.clipShape(.rect(cornerRadius: 25))
                    } else {
                      // Fallback on earlier versions
                    }
                    
                    /* Image("too_far")
                     .resizable()
                     .scaledToFit()*/
                    
                  }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    alignment: .topLeading
                  ).padding(.bottom, 10)
                  
                  ForEach((welcomeScreenOptions?["instructionPoint"] as! Array<String>).indices, id: \.self){index in
                    HStack(alignment: .top){
                      Text("\(index+1).").apply{
                        if #available(iOS 17.0, *) {
                          $0.foregroundStyle(colorScheme == .dark ? Color(hex: (colorConfigOptions!["onBackgroundDark"] as! String), opacity: 0.9) : Color(hex: (colorConfigOptions!["onBackgroundLight"] as! String), opacity: 0.9))
                        } else {
                          $0.foregroundColor(colorScheme == .dark ? Color(hex: (colorConfigOptions!["onBackgroundDark"] as! String), opacity: 0.9) : Color(hex: (colorConfigOptions!["onBackgroundLight"] as! String), opacity: 0.9))
                        }
                      }
                      Text("\((welcomeScreenOptions?["instructionPoint"] as! Array<String>)[index])").apply{
                        if #available(iOS 17.0, *) {
                          $0.foregroundStyle(colorScheme == .dark ? Color(hex: (colorConfigOptions!["onBackgroundDark"] as! String), opacity: 0.9) : Color(hex: (colorConfigOptions!["onBackgroundLight"] as! String), opacity: 0.9))
                        } else {
                          $0.foregroundColor(colorScheme == .dark ? Color(hex: (colorConfigOptions!["onBackgroundDark"] as! String), opacity: 0.9) : Color(hex: (colorConfigOptions!["onBackgroundLight"] as! String), opacity: 0.9))
                        }
                      }
                    }.padding(.bottom,0.1)
                  }
                  
                  HStack(alignment: .center){
                    Spacer()
                    Button(action: {
                      //print("Button tapped!")
                      self.hideWelcomeScreen = true
                      self.hideVerificationScreen = false
                      self.currentScreen = "VERIFICATION"
                      
                    }, label: {
                      Text("\(welcomeScreenOptions?["proceedButtonText"] as! String)").apply{
                        if #available(iOS 17.0, *) {
                          $0.foregroundStyle(colorScheme == .dark ? Color(hex: (colorConfigOptions!["onPrimaryDark"] as! String)) : Color(hex: (colorConfigOptions!["onPrimaryLight"] as! String)))
                        } else {
                          $0.foregroundColor(colorScheme == .dark ? Color(hex: (colorConfigOptions!["onPrimaryDark"] as! String)) : Color(hex: (colorConfigOptions!["onPrimaryLight"] as! String)))
                        }
                      }
                    }).padding(20)
                      .frame(height: 40, alignment: .center)
                      .background(RoundedRectangle(cornerRadius: 5)
                        .fill(colorScheme == .dark ? Color(hex: (colorConfigOptions!["primaryDark"] as! String)) : Color(hex: (colorConfigOptions!["primaryLight"] as! String)))
                        .shadow(color: .gray, radius: 1.5, x: 0, y: 0.5))
                    
                    Spacer()
                    
                  }.padding(.top, 20)
                  
                }
              }
              
            }.frame(
              maxWidth: .infinity,
              maxHeight: .infinity
            ).background(colorScheme == .dark ? Color(hex: (colorConfigOptions!["backgroundDark"] as! String)) : Color(hex: (colorConfigOptions!["backgroundLight"] as! String)) )
              .zIndex(1)
          }
        }.onAppear {
          
          if((optionsList["sessionId"] as! String).isEmpty){
            dataStore.onErrorCallbackEvent(["errorMessage" : "Invalid sessionId", "errorCause" : "missing sessionId or sessionId value is empty", "recoverySuggestion" : "please pass sessionId value in options" ])
          }
          
          let accessTokenData = optionsList["accessToken"] as! String
          
          if(accessTokenData.isEmpty){
            dataStore.onErrorCallbackEvent(["errorMessage" : "Invalid accessToken", "errorCause" : "missing accessToken or accessToken value is empty", "recoverySuggestion" : "please pass accessToken value in options" ])
          }
          
          Task {
            do {
              credentialsProvider = MyCredentialsProvider(accessToken: accessTokenData)
              
              do {
                let credentials = try await credentialsProvider?.fetchAWSCredentials()
                
              } catch let error as AuthError {
                
                dataStore.onErrorCallbackEvent(["errorMessage" : error.errorDescription, "errorCause" : "", "recoverySuggestion" : error.recoverySuggestion ])
              }
            } catch {
              dataStore.onErrorCallbackEvent(["errorMessage" :  "Unknown Error", "errorCause" : "", "recoverySuggestion" : "" ])
            }
          }
          
          if ((welcomeScreenOptions?["hideScreen"] as! Bool ) ) {
            hideWelcomeScreen = true
            hideVerificationScreen = false
            currentScreen = "VERIFICATION"
          }
          else{
            hideWelcomeScreen = false
            hideVerificationScreen = true
            currentScreen = "WELCOME"
          }
        }
        
        /**Colse Welcome  Screen Layout**/
        
        /**Verification  Screen Layout**/
        if (!hideVerificationScreen){
          
          VStack{
            
            FaceLivenessDetectorView(
              sessionID: optionsList["sessionId"] as! String,
              credentialsProvider: credentialsProvider ,
              region: "ap-south-1",
              disableStartView: verificationScreenOptions?["hideIntroScreen"] as! Bool,
              isPresented: $isPresentingLiveness,
              onCompletion: { result in
                switch result {
                case .success:
                  //print("Success")
                  dataStore.onSuccessCallbackEvent(["sessionId" : optionsList["sessionId"] as! String])
                  break;
                case .failure(let error):
                  //print("error :\(error)")
                  dataStore.onErrorCallbackEvent(["errorMessage" : error.message, "errorCause" : "", "recoverySuggestion" : error.recoverySuggestion ])
                  break;
                }
              }
            )
            
          }
          .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
          )
          .background(Color.white)
        }
        /** Close Verification  Screen Layout**/
      }
      .background(colorScheme == .dark ? Color(hex: (colorConfigOptions!["backgroundDark"] as! String)) : Color(hex: (colorConfigOptions!["backgroundLight"] as! String)) )
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity,
        alignment: .topLeading
      )
      
    }
    .background(colorScheme == .dark ? Color(hex: (colorConfigOptions!["backgroundDark"] as! String)) : Color(hex: (colorConfigOptions!["backgroundLight"] as! String)) )
    
  }
}

extension Color {
  init(hex: String, opacity: Double = 1.0) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
    default:
      (r, g, b) = (0, 0, 0)
    }
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue: Double(b) / 255,
      opacity: opacity
    )
  }
}

//help to check on os availability
extension View {
  func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
}

func reverseString(_ input: String) -> String {
  return String(input.reversed())
}

func decodeBase64(_ base64String: String) -> String? {
  if let data = Data(base64Encoded: base64String) {
    return String(data: data, encoding: .utf8)
  }
  return nil
}

struct MyAWSCredentials: AWSCredentials {
  let accessKeyId: String
  let secretAccessKey: String
}

struct MyAWSTemporaryCredentials: AWSCredentials, AWSTemporaryCredentials {
  let accessKeyId: String
  let secretAccessKey: String
  let sessionToken: String
  let expiration: Date
}

struct MyCredentialsProvider : AWSCredentialsProvider {
  
  let accessToken: String
  
  
  init(accessToken: String) {
    self.accessToken = accessToken
  }
  
  func fetchAWSCredentials() async throws -> any AWSCredentials {
    
    if(accessToken.isEmpty){
      throw AuthError.sessionExpired("Invalid to Decode accessToken", "Please check your accessToken and try again.")
    }
    
    if let decodedString = decodeBase64(accessToken) {
      
      let splitData = decodedString.components(separatedBy: "##")
      
      let data3 = splitData[0]
      
      let data2 = reverseString(splitData[1]);
      
      let data1 = reverseString(splitData[2]);
      
      let credentials = MyAWSTemporaryCredentials(
        accessKeyId: data1,
        secretAccessKey: data2,
        sessionToken: data3,
        expiration: Date().addingTimeInterval(3600) // 1 hour from now
      )
      
      // Check if the credentials are still valid
      if credentials.expiration > Date() {
        return credentials
      } else {
        throw AuthError.sessionExpired("AWS Credentials are expired", "Please check your credentials and try again.")
      }
      
    } else {
      throw AuthError.sessionExpired("Failed to Decode accessToken", "Please check your accessToken and try again.")
    }
  }
}*/
