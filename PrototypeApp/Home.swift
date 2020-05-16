//
//  Home.swift
//  PrototypeApp
//
//  Created by Christian From Rasmussen on 01/05/2020.
//  Copyright © 2020 Christian From. All rights reserved.
//

import SwiftUI

struct Home: View {
    @State var showProfile = false
    @State var showContent = false
    @State var stepsTextNumber = 0
    @State var viewState = CGSize.zero
    @State var showCard = false
    @State var bottomState = CGSize.zero
    @State var showFull = false
    @EnvironmentObject var user: UserStore
    
    
    var body: some View {
        ZStack {
            Color("background2")
                .edgesIgnoringSafeArea(.all)
            
            MenuView(showProfile: $showProfile)
                .background(Color.black.opacity(0.001))
                .offset(y: showProfile ? 50 : screen.height)
                .offset(y: viewState.height)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                .onTapGesture {
                    self.showProfile.toggle()
            }
            .gesture(
                DragGesture().onChanged { value in
                    self.viewState = value.translation
                }
                .onEnded { value in
                    if self.viewState.height > 50 {
                        self.showProfile = false
                    }
                    self.viewState = .zero
                }
            )
            
            HomeView(showProfile: $showProfile, showContent: $showContent, stepsTextNumber: 0)
                .padding(.top, 44)
                .background(
                    VStack {
                        LinearGradient(gradient: Gradient(colors:
                            [Color("background2"), Color("background1")]),
                                       startPoint: .top,
                                       endPoint: .bottom)
                            .frame(height: 200)
                        Spacer()
                    }
                    .background(Color("background1"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
                .clipShape(RoundedRectangle(cornerRadius: 2, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                //Rotere kortet når MenuView bliver trukket op eller ned
                .rotation3DEffect(Angle(degrees: showProfile ?
                    Double(viewState.height / 10) - 10 : 0), axis: (x: 10.0, y: 0, z: 0))
                .offset(y: showProfile ? -450 : 0)
                .scaleEffect(showProfile ? 0.9 : 1)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                .edgesIgnoringSafeArea(.top)
                        
            if user.showLogin {
                ZStack {
                    LoginView()
                    
                    VStack {
                        HStack {
                            Spacer()
                            
                            Image(systemName: "xmark")
                                .frame(width: 36, height: 36)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding()
                    .onTapGesture {
                        self.user.showLogin = false
                    }
                }
            }

            if showContent {
                BlurView(style: .systemMaterial).edgesIgnoringSafeArea(.all)
                
                QuestList()
                
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            //.environment(\.colorScheme, .dark)
            //.environment(\.sizeCategory, .extraExtraExtraLarge)
            .environmentObject(UserStore())
    }
}

struct AvatarView: View {
    @Binding var showProfile: Bool
    @EnvironmentObject var user: UserStore
    
    var body: some View {
        VStack {
            if user.isLogged {
                Button(action: {self.showProfile.toggle()}) {
                    Image("Avatar")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                }
            } else {
                Button(action: {self.user.showLogin.toggle()}) {
                    Image(systemName: "person")
                        .foregroundColor(.primary)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 36, height: 36)
                        .background(Color("background3"))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
            }
        }
    }
}

// Denne variable kan bruge i hele appen, fordi den er helt ude af de andres scope.
// Bruger den så jeg ikke hardcoder en skærm størrelse.
let screen = UIScreen.main.bounds
