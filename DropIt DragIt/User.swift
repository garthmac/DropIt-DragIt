//
//  User.swift
//  DragIt
//
//  Created by iMac 27 on 2015-10-15.
//  Copyright (c) 2015 Garth MacKenzie. All rights reserved.
//

import Foundation
struct User {
    let name: String
    let company: String?
    let highScore: String?
    let highScoreDate: String?
    let login: String
    let password: String
    var lastLogin = NSDate.demoRandom()
    
    init(name: String, company: String, highScore: String, highScoreDate: String, login: String, password: String) {
        self.name = name
        self.company = company
        self.highScore = highScore
        self.highScoreDate = highScoreDate
        self.login = login
        self.password = password
    }
    
    static func login(login: String, password: String) -> User {
        if let user = database[login] {
            if user.password == password {
            return user
            }
        }
        return User.login("baddie", password: "foo")
    }
    
    static let database: Dictionary<String, User> = {
        var theDatabase = Dictionary<String, User>()
        for user in [
            User(name: "Johny Appleseed", company: "Apple", highScore: "10,222", highScoreDate: "2015-04-01", login: "japple", password: "foo"),
            User(name: "Bad Guy", company: "Criminals, Inc.", highScore: "6,666", highScoreDate: "2015-06-06", login: "baddie", password: "foo"),
            User(name: "Good Guy", company: "Rescue, Inc.", highScore: "8,888", highScoreDate: "2015-06-21", login: "soccer", password: "foo"),
            User(name: "John", company: "Stanford", highScore: "999", highScoreDate: "2015-06-20", login: "asian40", password: "foo"),
            User(name: "Bad", company: "Criminals, Inc.", highScore: "6,666", highScoreDate: "2015-06-06", login: "balloonRing40", password: "foo"),
            User(name: "Good", company: "Rescue, Inc.", highScore: "8,888", highScoreDate: "2015-06-21", login: "perfect_bubble40", password: "foo"),
            User(name: "Johny", company: "Apple", highScore: "10,222", highScoreDate: "2015-04-01", login: "globe40", password: "foo"),
            User(name: "Madison", company: "World", highScore: "18,222", highScoreDate: "2015-05-11", login: "tennis40", password: "foo"),
            User(name: "John", company: "Stanford", highScore: "999", highScoreDate: "2015-06-20", login: "vectorA40", password: "foo"),
            User(name: "Bad", company: "Criminals, Inc.", highScore: "6,666", highScoreDate: "2015-06-06", login: "vectorB40", password: "foo"),
            User(name: "Good", company: "Rescue, Inc.", highScore: "8,888", highScoreDate: "2015-06-21", login: "cufi40", password: "foo"),
            User(name: "Johny", company: "Apple", highScore: "10,222", highScoreDate: "2015-04-01", login: "arrow40", password: "foo"),
            User(name: "Good", company: "Rescue, Inc.", highScore: "8,888", highScoreDate: "2015-06-21", login: "edd40", password: "foo"),
            User(name: "John", company: "Stanford", highScore: "999", highScoreDate: "2015-06-20", login: "burning40", password: "foo"),
            User(name: "Bad", company: "Criminals, Inc.", highScore: "6,666", highScoreDate: "2015-06-06", login: "bluePlanet40", password: "foo"),
            User(name: "Bad", company: "Criminals, Inc.", highScore: "6,666", highScoreDate: "2015-06-06", login: "Clouds_outer_space_planets_earth.jpg", password: "foo"),
            User(name: "Good", company: "Rescue, Inc.", highScore: "8,888", highScoreDate: "2015-06-21", login: "digital_art_1024x1024.jpg", password: "foo"),
            User(name: "Johny", company: "Apple", highScore: "10,222", highScoreDate: "2015-04-01", login: "glory.jpg", password: "foo"),
            User(name: "Madison", company: "World", highScore: "18,222", highScoreDate: "2015-05-11", login: "IMG_3562.jpg", password: "foo"),
            User(name: "John", company: "Stanford", highScore: "999", highScoreDate: "2015-06-20", login: "Outer_space_planets_earth_men_fantasy.jpg", password: "foo"),
            User(name: "Bad", company: "Criminals, Inc.", highScore: "6,666", highScoreDate: "2015-06-06", login: "space_3d_art_planet_earth_apocalyptic.jpg", password: "foo"),
            User(name: "Good", company: "Rescue, Inc.", highScore: "8,888", highScoreDate: "2015-06-21", login: "bluePlanet.jpg", password: "foo"),
            User(name: "Johny", company: "Apple", highScore: "10,222", highScoreDate: "2015-04-01", login: "Black_hole2048.jpg", password: "foo"),
            User(name: "Madison", company: "World", highScore: "18,222", highScoreDate: "2015-05-11", login: "heavensDeclare.jpg", password: "foo")
            ] {
            theDatabase[user.login] = user
        }
        return theDatabase
    }()
}

private extension NSDate {
    class func demoRandom() -> NSDate {
        let randomIntervalIntoThePast = -Double(arc4random() % 60*60*24*20)
        return NSDate(timeIntervalSinceNow: randomIntervalIntoThePast)
    }
}
