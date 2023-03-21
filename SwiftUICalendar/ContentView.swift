//
//  ContentView.swift
//  SwiftUICalendar
//
//  Created by Kaori Persson on 2023-03-21.
//https://note.com/taatn0te/n/nac4d35ea0890

import SwiftUI

struct ContentView: View {
    

    var body: some View {
        VStack {
          CalendarView(year: 2021, month: 9)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
