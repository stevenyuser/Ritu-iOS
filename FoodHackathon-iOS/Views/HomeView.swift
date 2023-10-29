//
//  HomeView.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/22/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: HomeViewModel = HomeViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack {
                    Spacer()
                        .frame(height: 20)
                    
                    HStack {
                        Text("Hello, \(vm.userModel?.displayName ?? "")")
                            .bold()
                            .font(.largeTitle)
                        Spacer()
                    }
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    CropRecsView()
                        .environmentObject(vm)
                }
                .padding(.horizontal)
                
            }
            // scrollview
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        vm.getCropRecs()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle.fill")
//                            .font(.system(size:20))
//                            .frame(width: 25, height: 25)
                            .padding(5)
                    }
                }
            }
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                vm.getCropRecs()
            }
//            vm.getDummyCropRecs()
        }
        
    }
}
