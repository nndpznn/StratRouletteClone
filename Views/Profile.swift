//
//  Profile.swift
//  FinalApp
//
//  Created by Adi Roitburg on 4/17/24.
//

import SwiftUI

struct Profile: View {
    @EnvironmentObject var auth: StratAuth
    @EnvironmentObject var chalService: ChallengeService
    @State var challenges: [Challenge]

    @State var showPosts: Bool = true
    @State var showPlaylists: Bool = false
    @State var showAbout: Bool = false
    @State var bio: String = "Proud member of Strat Roulette"
    @State var newBio: String = ""
    @State var editingBio: Bool = false
    
    var body: some View {
        VStack{
            ZStack{
//                LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                    .frame(width: 500, height: 2000)
//                    .edgesIgnoringSafeArea(.all)
                
                Rectangle()
                    .frame(width: 500, height: 5)
                
                Image("guy")
                    .resizable()
                    .clipShape(Circle())
                
                    .overlay(Circle().stroke(Color.black, lineWidth: 5))
                    .frame(width: 130, height: 130)
                    .offset(x: -90)
                
                if let user = auth.user{
                    Text(user.displayName ?? "")
                    .frame(width: 400, height: 30, alignment: .leading)
                    .font(.system(size: 35, weight: .bold))
                    .offset(x: 25, y: 100)
                    .foregroundColor(.black)
                }
                
//                Text("Adi Roitburg")
//                    .frame(width: 400, height: 30, alignment: .leading)
//                    .font(.system(size: 35, weight: .bold))
//                    .offset(x: 25, y: 100)
//                    .foregroundColor(.black)
                
                HStack{
                    
                    Spacer()
                    
                    if showPosts{
                        Text("Posts")
                            .font(.system(size: 25, weight: .bold))
                            .offset(y: 175)
                            .foregroundColor(.black)
                    } else {
                        Text("Posts")
                            .font(.system(size: 25, weight: .regular))
                            .offset(y: 175)
                            .foregroundColor(.black)
                            .onTapGesture {
                                showPosts = true
                                showPlaylists = false
                                showAbout = false
                            }
                    }
        
            
                    Spacer()
                    
                    if showPlaylists{
                        Text("Playlists")
                            .font(.system(size: 25, weight: .bold))
                            .offset(y: 175)
                    } else {
                        Text("Playlists")
                            .font(.system(size: 25, weight: .regular))
                            .offset(y: 175)
                            .onTapGesture {
                                showPosts = false
                                showPlaylists = true
                                showAbout = false                            }
                    }
                    
                    Spacer()
                    
                    if showAbout {
                        Text("About")
                            .font(.system(size: 25, weight: .bold))
                            .offset(y: 175)
                    } else {
                        Text("About")
                            .font(.system(size: 25, weight: .regular))
                            .offset(y: 175)
                            .onTapGesture {
                                showPosts = false
                                showPlaylists = false
                                showAbout = true
                            }
                    }
                    
                    Spacer()

                }
                .padding()
                
                Rectangle()
                    .frame(width: 500, height: 3)
                    .foregroundColor(.gray)
                    .offset(y: 200)
                
                if showPosts{
                    List(challenges) { chal in
                        NavigationLink{
                            ChallengeDetail(challenge: chal)
                        } label: {
                            ChallengeItem(challenge: chal)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    .offset(y: 475)
                    .frame(width: 400, height: 500)
                } else if showPlaylists {
                    
                } else if showAbout{
                    if (!editingBio){
                        VStack{
                            Button("Enter New Bio +") {
                                editingBio = true
                            }
                            Text("Bio: \(bio)")
                                .frame(width: 350, height: 250, alignment: .topLeading)
                            
                            
                            
                        }
                        .offset(y: 350)
                    } else {
                        VStack{
                            Button("Save"){
                                bio = newBio
                                editingBio = false
                            }
                            TextField("Enter new bio", text: $newBio)
                                .frame(width: 350, height: 250, alignment: .topLeading)
                        
                        }
                        .offset(y: 350)
                    }
                }
            }
            .offset(y: -275)
        }
        .task{
            do{
                challenges = try await chalService.fetchChallenges()
            } catch {
                // Error handling goes here
            }
        }
        
        
    }
}

#Preview {
    Profile(challenges: [exampleChallenge1, exampleChallenge2, exampleChallenge3, exampleChallenge1, exampleChallenge1])
        .environmentObject(StratAuth())
        .environmentObject(ChallengeService())
}
