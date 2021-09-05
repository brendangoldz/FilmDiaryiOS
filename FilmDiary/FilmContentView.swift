//
//  FilmContentView.swift
//  FilmContentView
//
//  Created by Brendan Goldsmith on 9/3/21.
//

import SwiftUI

struct FilmContentView: View {
    @State var films : [Film] = [];
    @State private var isShowingEditForm: Int? = 0;

    var body: some View {
            List(films) { film in
                let newRate = Float(film.rating);
                let widthModifier: CGFloat = CGFloat(newRate / 100.0);
                ScrollView(.vertical){
                    
                    Text("\(film.name) : \(film.rating)")
                    NavigationLink(destination:FilmFormView(filmIdentifier: film.id, sliderVal: Double(newRate), titleValue: film.name, alertStruct: FilmAlert()), label: {
                        Label("Edit Item", systemImage: "pencil")
                    })
                    .padding(5)
                    .accentColor(Color.red);
                }
                .frame(width: 250, height: 75)
                .padding(.all, 5)
                .background(
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .foregroundColor(getFillColor(rating: newRate))
                                .frame(width: geometry.size.width * CGFloat(widthModifier), height: geometry.size.height)
                                .cornerRadius(10)
                        }
                    }
                )
            }
            .onAppear(perform: {
                API().getFilms(completion: {
                    (films) in
                    self.films = films;
                });
            })
    }

    
    func getFillColor(rating: Float) -> Color {
        var fillColor = Color.yellow;
        if(rating > 65){
            fillColor = Color.green;
        }
        else if(rating < 45){
            fillColor =  Color.red;
        }
        return fillColor;
    }
}

struct FilmContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilmContentView()
    }
}
