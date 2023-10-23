//
//  CropRecsView.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/22/23.
//

import SwiftUI

struct CropRecsView: View {
    @EnvironmentObject var vm: HomeViewModel
    
    @State var sentSMS: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text("Your Weekly Crop Projections")
                    .foregroundColor(Color("RituGreen"))
                    .bold()
                    .font(.title)
                Spacer()
            }
            
            // should be a foreach for all the crops, but for demo, only showing rice
            VStack {
                HStack {
                    Text("Rice")
                        .bold()
                        .font(.title2)
                    Spacer()
                }
                
                Divider()
                    .overlay(.white)
                
                
                if !vm.gotData {
                    Spacer()
                    
                    ProgressView()
                        .tint(Color.white)
                        .scaleEffect(3)
                        .padding()
                    
                    Spacer()
                } else {
                    
                    Group {
                        HStack {
                            Label("Pest Risk", systemImage: "ant.fill")
                                .font(.headline)
                            
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        
                        ForEach(vm.cropRecs.pests, id:\.self) { pest in
                            HStack {
                                Text(pest.name)
                                
                                Spacer()
                                
                                Text(pest.riskLevel)
                                    .bold()
                            }
                        }
                    }
                        
                    Divider()
                        .overlay(.white)
                    
                    Group {
                        HStack {
                            Label("Possible Extreme Weather", systemImage: "exclamationmark.triangle.fill")
                                .font(.headline)
                            
                            Spacer()
                        }
                        
                        Text(vm.cropRecs.extremeWeatherConditions)
                            .bold()
                            .font(.title2)
                            .padding(.vertical)
                    }
                    
                    Divider()
                        .overlay(.white)
                    
                    Group {
                        Button {
                            vm.sendSMS()
                            self.sentSMS = true
                        } label: {
                            Text("Send SMS Notification")
                                .bold()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color("RituGreen"))
                                .background(Color.white)
                                .clipShape(.rect(cornerRadius: 16))
                                .padding(.horizontal)
                        }
                        .opacity(!sentSMS ? 1 : 0.25)
                        .disabled(sentSMS)

                    }
                }
                
            }
            .foregroundColor(Color.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color("RituGreen"))
            )
        }
    }
}
