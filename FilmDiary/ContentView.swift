//
//  ContentView.swift
//  FilmDiary
//
//  Created by Brendan Goldsmith on 9/3/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var showView: Bool = false;
    @State var API_REF = API();
    var body: some View {
        HStack {
            Text("Film Diary").padding(5).font(.largeTitle)
        }

        NavigationView {
            VStack {
                Text("Record and Rate Movies You Watch!").font(.title3).padding(10).offset(y: -5)

                HStack{
                    NavigationLink(destination:FilmContentView(), label: {
                        Text("Get Films").frame(width: 125, height: 50)
                    }).padding(3.5)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    Spacer(minLength: 1.0).frame(width: 10)
                    NavigationLink(destination:FilmFormView(alertStruct: FilmAlert()), label: {
                        Text("Add a Film").frame(width: 125, height: 50)
                    }).padding(3.5)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }.offset(y: -15)
            }
            
     
        }
        
        Button(action:{
            self.showView.toggle();
        }){
            Text("Login").frame(width: 250, height: 75)
        }.sheet(isPresented: $showView){
            LoginView()
        }.background(
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.green)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .cornerRadius(10)
                    }
                })
            .foregroundColor(.white)
//            .disabled(defaults.string(forKey: "jwtToken") != nil)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
