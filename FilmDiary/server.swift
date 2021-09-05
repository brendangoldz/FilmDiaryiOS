//
//  FilmContentMWare.swift
//  FilmContentMWare
//
//  Created by Brendan Goldsmith on 9/3/21.
//

import Foundation
import SwiftUI
let defaults = UserDefaults.standard;

struct Film : Identifiable, Codable {
    var id: Int
    var name: String
    var rating: Int
}
class User {
    struct ID: Codable {
        var username: String
    }
    struct TOKEN: Codable {
        var token: String
    }
}
class API {
    func getFilms(completion: @escaping ([Film]) ->()) {
        let URL = URL(string: "http://192.168.1.21:8080/api/v1/films/");
        guard let requestUrl = URL else { fatalError() }
        var request = URLRequest(url: requestUrl);
        print("In getFilms")
        request.httpMethod = "GET";
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let error = err {
                print("Error \(error)");
                return
            }
            if let response = response as? HTTPURLResponse{
                print("Response Received: \(response.statusCode)");
            }
            let films = try! JSONDecoder().decode([Film].self, from: data!)
             DispatchQueue.main.async {
                 completion(films);
             }
        }.resume();
        
 
//        List {
//            ForEach(filmList) { film in
//                Text("Film at \(film.name)").font(.system(size: 40))
//            }
//        }
    }
    
    func createFilm(newName: String, newRating: Int, authToken: String, completion: @escaping (HTTPURLResponse) ->()) {
        let URL = URL(string: "http://192.168.1.21:8080/api/v1/films/add/");
        guard let requestUrl = URL else { fatalError() }
        var request = URLRequest(url: requestUrl);
        request.httpMethod = "POST";
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        let newFilm: Film = Film(id: -1, name: newName, rating: newRating);
        let jsonData = try! JSONEncoder().encode(newFilm);
        request.httpBody = jsonData;
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    print("error", error ?? "Unknown error")
                    return
                }

            DispatchQueue.main.async {
                completion(response);
            }
        }.resume();
    }
    
    func editFilm(newId: Int, newName: String, newRating: Int, authToken: String, completion: @escaping (HTTPURLResponse) ->()) {
        let URL = URL(string: "http://192.168.1.21:8080/api/v1/films/edit/");
        guard let requestUrl = URL else { fatalError() }
        var request = URLRequest(url: requestUrl);
        request.httpMethod = "PUT";
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        let newFilm: Film = Film(id: newId, name: newName, rating: newRating);
        let jsonData = try! JSONEncoder().encode(newFilm);
        request.httpBody = jsonData;
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    print("error", error ?? "Unknown error")
                    return
                }
             DispatchQueue.main.async {
                 completion(response);
             }
        }.resume();
    }
    
    func login(usernameIn: String) {
        let URL = URL(string: "http://192.168.1.21:8080/api/v1/login/");
        guard let requestUrl = URL else { fatalError() }
        var request = URLRequest(url: requestUrl);
        print("In getFilms")
        request.httpMethod = "POST";
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let newUser: User.ID = User.ID(username: usernameIn);
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let userJsonData = try! encoder.encode(newUser);
        print(String(data: userJsonData, encoding: .utf8)!)
        
        request.httpBody = userJsonData;
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    print("error", error ?? "Unknown error")
                    return
                }
    
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            let returnedUser = try! JSONDecoder().decode(User.TOKEN.self, from: data)
            print("User: \(returnedUser)")
            defaults.set(returnedUser.token, forKey:"jwtToken");
        }.resume();
    }
}
class UserTextValidator: ObservableObject {

    @Published var text = ""

}

class FilmTextValidator: ObservableObject {
    @Published var name = ""
    @Published var rating:Int = 0
}
