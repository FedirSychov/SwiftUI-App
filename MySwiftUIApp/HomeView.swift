//
//  HomeView.swift
//  MySwiftUIApp
//
//  Created by Fedor Sychev on 02.09.2021.
//


import SwiftUI

struct HomeView: View {
    @Binding var showProfile: Bool
    @State var showUpdate = false
    @Binding var showContent: Bool
    @Binding var viewState: CGSize
    @ObservedObject var store = courseStore()
    @State var active = false
    @State var activeIndex = -1
    @State var activeView = CGSize.zero
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var isScrollable = false
    
    var body: some View {
        GeometryReader { bounds in
            ScrollView {
                VStack {
                    HStack(spacing: 12) {
                        Text("Watching")
                            .modifier(CustomFontModifier( ))
                        
                        Spacer()
                        
                        AvatarView(showProfile: self.$showProfile)
                        
                        Button(action: {
                            self.showUpdate.toggle()
                        }, label: {
                            Image(systemName: "bell")
    //                            .renderingMode(.original)
                                .foregroundColor(.primary)
                                .font(.system(size: 20, weight: .medium))
                                .frame(width: 36, height: 36, alignment: .center)
                                .background(Color("background3"))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1.0)
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10.0)
                        })
                        .sheet(isPresented: $showUpdate, content: {
                            UpdateList()
                        })
                    }
                    .padding(.horizontal)
                    .padding(.leading, 14)
                    .padding(.top, 30)
                    .blur(radius: self.active ? 20 : 0)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        WatchringsView()
                            .padding(.horizontal, 30)
                            .padding(.bottom, 30)
                            .onTapGesture {
                                self.showContent = true
                            }
                    }
                    .blur(radius: self.active ? 20 : 0)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(sectionData) { item in
                                GeometryReader { geometry in
                                    SectionView(section: item)
                                        .rotation3DEffect(
                                            .degrees(Double(geometry.frame(in: .global).minX) - 30) / -getAngleMultiplier(bounds: bounds),
                                            axis: (x: 0.0, y: 10, z: 0.0)
                                        )
                                }
                                .frame(width: 275, height: 275)
                            }
                        }
                        .padding(30)
                        .padding(.bottom, 30)
                    }
                    .offset(y: -30)
                    .blur(radius: self.active ? 20 : 0)
                    
                    HStack {
                        Text("Courses")
                            .font(.title).bold()
                        Spacer()
                    }
                    .padding(.leading, 30)
                    .offset(y: -60)
                    .blur(radius: self.active ? 20 : 0)
                    
                    VStack(spacing: 30) {
                        ForEach(store.courses.indices, id: \.self) { index in
                            GeometryReader { geometry in
                                CourseView(
                                    show: self.$store.courses[index].show,
                                    course: self.store.courses[index],
                                    active: self.$active,
                                    index: index,
                                    activeIndex: self.$activeIndex,
                                    activeView: self.$activeView,
                                    bounds: bounds, isScrollable: self.$isScrollable
                                )
                                .offset(y: self.store.courses[index].show ? -geometry.frame(in: .global).minY : 0)
                                    .opacity(self.activeIndex != index && self.active ? 0 : 1)
                                    .scaleEffect(self.activeIndex != index && self.active ? 0.5 : 1)
                                    .offset(x: self.activeIndex != index && self.active ? bounds.size.width : 0)
                            }
                            .frame(height: self.horizontalSizeClass == .regular ? 80 : 280)
                            .frame(maxWidth: self.store.courses[index].show ? 712 : getCardWith(bounds: bounds))
                            .zIndex(self.store.courses[index].show ? 1 : 0)
                        }
                    }
                    .padding(.bottom, 300)
                    .offset(y: -60)
                    
                    Spacer()
                }
                .frame(width: bounds.size.width)
                .offset(y: self.showProfile ? -450 : 0)
                .rotation3DEffect(
                    .degrees(self.showProfile ? Double(self.viewState.width/10) - 10 : 0),
                    axis: (x: 10.0, y: 0.0, z: 0.0)
                )
                .scaleEffect(self.showProfile ? 0.9 : 1)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            }
            .disabled(self.active && !isScrollable ? true : false)
        }
    }
}

func getAngleMultiplier(bounds: GeometryProxy) -> Double {
    if bounds.size.width > 500 {
        return 80
    } else {
        return 20
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VStack {
                HomeView(showProfile: .constant(false), showContent: .constant(false), viewState: .constant(.zero))
                    .environmentObject(UserStore())
            }
        }
    }
}

struct SectionView: View {
    var section: Section
    var width: CGFloat = 275
    var height: CGFloat = 275
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text(section.title)
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 160, alignment: .leading)
                    .foregroundColor(.white)
                Spacer()
                Image(section.logo)
            }
            
            Text(section.text.uppercased())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            section.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 210)
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .frame(width: width, height: height, alignment: .center)
        .background(section.color)
        .cornerRadius(30)
        .shadow(color: section.color.opacity(0.4), radius: 20, x: 0, y: 20)
    }
}

struct Section: Identifiable {
    var id = UUID()
    var title: String
    var text: String
    var logo: String
    var image: Image
    var color: Color
}

let sectionData: [Section] = [
    Section(title: "Prototype designs in SwiftUI", text: "18 Sections", logo: "Logo1", image: Image(uiImage: #imageLiteral(resourceName: "Card4")), color: Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))),
    Section(title: "Build a SwiftUI app", text: "20 Sections", logo: "Logo1", image: Image(uiImage: #imageLiteral(resourceName: "Background1")), color: Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))),
    Section(title: "SwiftUI advanced", text: "20 Sections", logo: "Logo1", image: Image(uiImage: #imageLiteral(resourceName: "Card2")), color: Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
]

struct WatchringsView: View {
    var body: some View {
        HStack(spacing: 30) {
            HStack(spacing: 20) {
                RingView(color1: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), color2: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) , width: 44, height: 44, percent: 68, show: .constant(true))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("6 minutes left")
                        .bold()
                        .modifier(FontModifier(style: .subheadline))
                    Text("Watched 10 munites today")
                        .modifier(FontModifier(style: .caption))
                }
                .modifier(FontModifier())
            }
            .padding(8)
            .background(Color("background3"))
            .cornerRadius(20)
            .modifier(ShadowModifier())
            
            HStack(spacing: 20) {
                RingView(color1: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), color2: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) , width: 32, height: 32, percent: 54, show: .constant(true))
            }
            .padding(8)
            .background(Color("background3"))
            .cornerRadius(20)
            .modifier(ShadowModifier())
            
            HStack(spacing: 20) {
                RingView(color1: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), color2: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) , width: 32, height: 32, percent: 32, show: .constant(true))
            }
            .padding(8)
            .background(Color("background3"))
            .cornerRadius(20)
            .modifier(ShadowModifier())
        }
    }
}
