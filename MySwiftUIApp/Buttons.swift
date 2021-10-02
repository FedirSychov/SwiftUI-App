//
//  Buttons.swift
//  MySwiftUIApp
//
//  Created by Fedor Sychev on 28.09.2021.
//

import SwiftUI

func haptic(type: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator().notificationOccurred(type)
}

func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}

struct Buttons: View {
    var body: some View {
        VStack(spacing: 50) {
            RectangleButton()
            
            CirleButton()
            
            PayButton()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.88, green: 0.9, blue: 0.97))
        .edgesIgnoringSafeArea(.all)
        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        Buttons()
    }
}

struct RectangleButton: View {
    @State var tap = false
    @State var press = false
    
    var body: some View {
        Text("Button")
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .frame(width: 200, height: 60)
            .background(
                ZStack {
                    press ? Color.white : Color(red: 0.76, green: 0.82, blue: 0.92)
                    
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .foregroundColor(press ? Color(red: 0.76, green: 0.82, blue: 0.92) : Color.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color(red: 0.83, green: 0.85, blue: 0.92), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .padding(3)
                        .blur(radius: 2)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                HStack {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(Color.white.opacity(press ? 0 : 1))
                        .frame(width: press ? 64 : 54, height: press ? 4 : 50)
                        .background(Color(red: 100/255, green: 0, blue: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(red: 100/255, green: 0, blue: 1).opacity(0.3), radius: 10, x: 10, y: 10)
                        .offset(x: press ? 70 : -10, y: press ? 16 : 0)
                    
                    Spacer()
                }
            )
            .shadow(color: press ? Color.white : Color(red: 0.76, green: 0.82, blue: 0.92), radius: 20, x: 20, y: 20)
            .shadow(color: press ? Color(red: 0.76, green: 0.82, blue: 0.92) : Color.white, radius: 20, x: -20, y: -20)
            .scaleEffect(tap ? 1.2 : 1)
            .gesture(
                LongPressGesture(minimumDuration: 0.5, maximumDistance: 10).onChanged({ value in
                    self.tap = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.tap = false
                    }
                })
                    .onEnded({ value in
                        self.press.toggle()
                    })
            )
    }
}

struct CirleButton: View {
    @State var tap = false
    @State var press = false
    
    var body: some View {
        ZStack {
            Image(systemName: "sun.max")
                .font(.system(size: 44, weight: .light))
                .offset(x: press ? -90 : 0, y: press ? -90 : 0)
                .rotation3DEffect(Angle(degrees: press ? 20 : 0), axis: (x: 10, y: 10, z: 0))
            
            Image(systemName: "moon")
                .font(.system(size: 44, weight: .light))
                .offset(x: press ? 0 : 90, y: press ? 0 : 90)
                .rotation3DEffect(Angle(degrees: press ? 0 : 20), axis: (x: -10, y: 10, z: 0))
        }
        .frame(width: 100, height: 100)
        .background(
            ZStack {
                LinearGradient(gradient: Gradient(colors: [press ? Color(red: 0.88, green: 0.9, blue: 0.97) : Color.white, press ? Color.white : Color(red: 0.88, green: 0.9, blue: 0.97)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                
                Circle()
                    .stroke(Color.white.opacity(0.0001), lineWidth: 10)
                    .shadow(color: press ? Color(red: 0.76, green: 0.82, blue: 0.92) : Color.white, radius: 3, x: 4, y: 4)
                
                Circle()
                    .stroke(Color.gray.opacity(0.0001), lineWidth: 10)
                    .shadow(color: press ? Color.clear : Color(red: 0.76, green: 0.82, blue: 0.92), radius: 3, x: -4, y: -4)
                
            }
        )
        .clipShape(Circle())
        .shadow(color: press ? Color(red: 0.76, green: 0.82, blue: 0.92) : Color.white, radius: 20, x: -20, y: -20)
        .shadow(color: press ? Color.white : Color(red: 0.76, green: 0.82, blue: 0.92), radius: 20, x: 20, y: 20)
        .scaleEffect(tap ? 1.2 : 1)
        .gesture(
            LongPressGesture().onChanged({ value in
                self.tap = true
                impact(style: .heavy)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.tap = false
                }
            })
                .onEnded({ value in
                    self.press.toggle()
                    haptic(type: .success)
                })
        )
    }
}

struct PayButton: View {
    @GestureState var tap = false
    @State var press = false
    
    var body: some View {
        ZStack {
            Image("fingerprint")
                .opacity(press ? 0 : 1)
                .scaleEffect(press ? 0 : 1)
            
            Image("fingerprint-2")
                .clipShape(Rectangle().offset(y: tap ? 0 : 50))
                .animation(.easeInOut)
                .opacity(press ? 0 : 1)
                .scaleEffect(press ? 0 : 1)
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 44, weight: .light))
                .foregroundColor(Color(red: 100/255, green: 0, blue: 1))
                .opacity(press ? 1 : 0)
                .scaleEffect(press ? 1 : 0)
        }
        .frame(width: 120, height: 120)
        .background(
            ZStack {
                LinearGradient(gradient: Gradient(colors: [press ? Color(red: 0.88, green: 0.9, blue: 0.97) : Color.white, press ? Color.white : Color(red: 0.88, green: 0.9, blue: 0.97)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                
                Circle()
                    .stroke(Color.white.opacity(0.0001), lineWidth: 10)
                    .shadow(color: press ? Color(red: 0.76, green: 0.82, blue: 0.92) : Color.white, radius: 3, x: 4, y: 4)
                
                Circle()
                    .stroke(Color.gray.opacity(0.0001), lineWidth: 10)
                    .shadow(color: press ? Color.clear : Color(red: 0.76, green: 0.82, blue: 0.92), radius: 3, x: -4, y: -4)
                
            }
        )
        .clipShape(Circle())
        .overlay(
            Circle()
                .trim(from: tap ? 0.001 : 1, to: 1)
                .stroke(LinearGradient(gradient: Gradient(colors: [Color(red: 100/255, green: 0, blue: 1), Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: 88, height: 88)
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .shadow(color: Color.purple.opacity(0.3), radius: 5, x: 3, y: 3)
                .animation(.easeInOut)
        )
        .shadow(color: press ? Color(red: 0.76, green: 0.82, blue: 0.92) : Color.white, radius: 20, x: -20, y: -20)
        .shadow(color: press ? Color.white : Color(red: 0.76, green: 0.82, blue: 0.92), radius: 20, x: 20, y: 20)
        .scaleEffect(tap ? 1.2 : 1)
        .gesture(
            LongPressGesture().updating($tap) { currentState, gestureState, transaction in
                gestureState = currentState
                impact(style: .heavy)
            }
                .onEnded({ value in
                    self.press.toggle()
                    haptic(type: .success)
                })
        )
    }
}
