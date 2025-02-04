//
//  UserRow.swift
//  randomuser
//
//  Created by Pau on 4/2/25.
//

import SwiftUI

struct UserRow: View {
    let user: User
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.pictureURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("\(user.firstName) \(user.lastName)")
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(user.phone)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
    }
}
