//
//  User.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

import Foundation

public struct User: Identifiable, Equatable, Hashable, Codable {
    public let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let pictureURL: String
}
