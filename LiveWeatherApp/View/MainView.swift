//
//  ContentView.swift
//  LiveWeatherApp
//
//  Created by Lov Lamba on 04/04/23.
//

import SwiftUI
import CoreLocation

struct MainView: View {
    @StateObject var model = MainViewModel()
    @State var weather: Weather?
    @State var showAlert = false
    @State var alertMsg = ""
    
    var body: some View {
        VStack {
            if let weather = weather {
                WeatherMainView(weather: weather, location: model.location!).edgesIgnoringSafeArea(.top)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(self.alertMsg), message: Text("Please check your network connection"), dismissButton: .default(Text("Try Again"), action: {
                self.showAlert = false
                self.getData()
            }))
        }
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
        .onChange(of: model.location){ location in
            self.getData()
        }
    }
    
    func getData(){
        Task{
            if let location = model.location{
                if let weather = await model.getCurrentWeather(location: location){
                    self.weather = weather
                }
                else{
                    alertMsg = "Could not fetch the current weather."
                    showAlert = true
                }
            }
            else{
                print("Could not get your location.")
                showAlert = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}