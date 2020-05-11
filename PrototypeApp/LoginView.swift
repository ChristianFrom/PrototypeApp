//
//  LoginView.swift
//  PrototypeApp
//
//  Created by Christian From Rasmussen on 11/05/2020.
//  Copyright © 2020 Christian From. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var isFocused = false
    @State var showAlert = false
    @State var alertMessage = "Something went wrong..."
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .top) {
                
                Color("background2")
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))            .edgesIgnoringSafeArea(.bottom)
                
                CoverView()
                
                VStack {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5 )
                            .padding(.leading, 16)
                        
                        
                        TextField("Your e-mail".uppercased(), text: $email)
                            .keyboardType(.emailAddress)
                            .font(.subheadline)
                            //.textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.leading)
                            .frame(height: 44)
                            .onTapGesture {
                                self.isFocused = true
                        }
                    }
                    
                    Divider().padding(.leading, 80)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5 )
                            .padding(.leading, 16)
                        
                        
                        SecureField("Password".uppercased(), text: $password)
                            .keyboardType(.default)
                            .font(.subheadline)
                            //.textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.leading)
                            .frame(height: 44)
                            .onTapGesture {
                                self.isFocused = true
                        }
                    }
                }
                .frame(height: 136)
                .frame(maxWidth: .infinity)
                .background(BlurView(style: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 20)
                .padding(.horizontal)
                .offset(y: 460)
                
                HStack {
                    Text("Forgot password?")
                        .font(.subheadline)
                    Spacer()
                    
                    Button(action: {
                        self.showAlert = true
                        self.hideKeyboard()
                        self.isFocused = false
                    }) {
                        Text("Log in")
                            .foregroundColor(.black)
                        
                    }
                    .padding(12)
                    .padding(.horizontal, 30)
                    .background(Color(#colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)).opacity(0.3), radius: 20, x: 0, y: 20)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text(self.alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding()
                
            }
                //Rykker det hele op, når isFocused er true
                .offset(y: isFocused ? -300 : 0)
                .animation(isFocused ? .easeInOut : nil)
                .onTapGesture {
                    self.isFocused = false
                    self.hideKeyboard()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct CoverView: View {
    @State var show = false
    @State var viewState = CGSize.zero
    @State var isDragging = false
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Text("Noget sejt lorem ipsum tekst...\nVery cool")
                    .font(.system(size: geometry.size.width / 10, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: 375, maxHeight: 100)
            .padding(.horizontal, 16)
                //Giver en 3D parallex effect
                .offset(x: viewState.width / 15, y: viewState.height / 15)
            
            
            Text("Noget mere tekst, jadadad lorem ipsum dolores nice")
                .font(.subheadline)
                .frame(width: 250)
                //Giver en 3D parallex effect
                .offset(x: viewState.width / 20, y: viewState.height / 20)
            
            
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding(.top, 100)
        .frame(height: 477)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                Image(uiImage: #imageLiteral(resourceName: "Blob"))
                    .offset(x: -150, y:-200)
                    .rotationEffect(Angle(degrees: show ? 360 + 90 : 90))
                    .blendMode(.plusDarker)
                    // .animation(Animation.linear(duration: 120).repeatForever(autoreverses: false))
                    .onAppear{ self.show = true }
                
                Image(uiImage: #imageLiteral(resourceName: "Blob"))
                    .offset(x: -250, y:-250)
                    .rotationEffect(Angle(degrees: show ? 360 : 0), anchor: .leading)
                    .blendMode(.overlay)
                //.animation(Animation.linear(duration: 100).repeatForever(autoreverses: false))
            }
        )
            .background(
                Image(uiImage: #imageLiteral(resourceName: "Card1"))
                    //Giver en 3D parallex effect
                    .offset(x: viewState.width / 25, y: viewState.height / 25)
                ,alignment: .bottom
        )
            .background(Color(#colorLiteral(red: 0.396982491, green: 0.4729263186, blue: 1, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .scaleEffect(isDragging ? 0.9 : 1)
            .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
            .rotation3DEffect(Angle(degrees: 5), axis: (x: viewState.width, y: viewState.height, z: 0))
            .gesture(
                DragGesture().onChanged{ value in
                    self.viewState = value.translation
                    self.isDragging = true
                }
                .onEnded{ value in
                    self.viewState = .zero
                    self.isDragging = false
                }
        )
    }
}