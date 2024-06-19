//
//  MainScreenView.swift
//  react-native-instantpay-faceliveness
//
//  Created by Dhananjay Kumar on 27/04/24.
//

import SwiftUI

struct MainScreenView: View {
    
    //@Binding var options: [String: Any]
    
    @EnvironmentObject var dataStore: MyDataStore
    
    @State private var isPresentingLiveness = false
    
    @State private var instructionList = [
        "When an oval appears, fill the oval with your face within 7 seconds.",
        "Maximize vour screen's brightness.",
        "Make sure your face is not covered with sunglasses or a mask.",
        "Move to a well-lit place that is not in direct sunlight.",
        "This check displays colored lights. Use caution if you are photosensitive."
    ]
    
    var body: some View {
        
        let configItem = dataStore.options
        
        VStack {
            
            /**Title Layout**/
            HStack{
                
                if let title = configItem["title"] {
                    
                    Text("\(title)")
                        .font(Font.system(size:26,design: .default))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                }
                
                Spacer()
                
                Image(systemName: "xmark")
                    .font(Font.system(size: 22, weight: .bold)).onTapGesture {
                        dataStore.onErrorCallback(["data": "some data by native side"])
                    }
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .topLeading
            ).padding(.bottom, 5)
            
            /**Close Title Layout**/
            
            ZStack(alignment: .bottom) {
                
                /**Welcome  Screen Layout**/
                VStack{
                    
                    ScrollView{
                        
                        VStack(alignment: .leading){
                            
                            Text("You will go through a face verification process to prove that you are a real person.")
                                .padding(.bottom, 10)
                                .apply{
                                    if #available(iOS 17.0, *) {
                                        $0.foregroundStyle(Color(hex: "#000000", opacity: 0.5))
                                    } else {
                                        $0.foregroundColor(Color(hex: "#000000", opacity: 0.5))
                                    }
                                }
                            
                            Text("Follow the instructions to complete the check:")
                                .padding(.bottom, 3)
                                .apply{
                                    if #available(iOS 17.0, *) {
                                        $0.foregroundStyle(Color(hex: "#000000"))
                                    } else {
                                        $0.foregroundColor(Color(hex: "#000000"))
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
                            
                            ForEach(instructionList.indices, id: \.self){index in
                                HStack(alignment: .top){
                                    Text("\(index+1).").apply{
                                        if #available(iOS 17.0, *) {
                                            $0.foregroundStyle(Color(hex: "#000000", opacity:0.9))
                                        } else {
                                            $0.foregroundColor(Color(hex: "#000000", opacity:0.9))
                                        }
                                    }
                                    Text("\(self.instructionList[index])").apply{
                                        if #available(iOS 17.0, *) {
                                            $0.foregroundStyle(Color(hex: "#000000", opacity:0.9))
                                        } else {
                                            $0.foregroundColor(Color(hex: "#000000", opacity:0.9))
                                        }
                                    }
                                }.padding(.bottom,0.1)
                            }
                            
                            HStack(alignment: .center){
                                Spacer()
                                Button(action: {
                                    print("Button tapped!")
                                }, label: {
                                    Text("Proceed Liveness Check")
                                }).padding(20)
                                    .frame(height: 40, alignment: .center)
                                    .background(RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.white)
                                        .shadow(color: .gray, radius: 1.5, x: 0, y: 0.5))
                                
                                Spacer()
                                
                            }.padding(.top, 20)
                            
                        }
                    }
                    
                }.frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                ).background(Color.white)
                    .zIndex(1)
                
                /**Colse Welcome  Screen Layout**/
                
                /**Verification  Screen Layout**/
                VStack{
                    
                    /*FaceLivenessDetectorView(
                        sessionID: "4181e486-8f0c-4a3f-bf59-2ac14119b4f9",
                        region: "ap-south-1",
                        isPresented: $isPresentingLiveness,
                        onCompletion: { result in
                            switch result {
                            case .success:
                                print("Success")
                                break;
                            case .failure(let error):
                                print("error :\(error)")
                                break;
                            default:
                                
                                break;
                            }
                        }
                    )*/
                    
                }.frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
                .background(Color.white)
                
                /** Close Verification  Screen Layout**/
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            
        }.padding(2)
    }
}

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
}

//help to check on os availability
extension View {
    func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
}
