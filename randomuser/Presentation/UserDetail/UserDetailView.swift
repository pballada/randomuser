//
//  UserDetailView.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import SwiftUI

struct UserDetailView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: user.pictureURL)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            .padding()
            
            Text("\(user.firstName) \(user.lastName)")
                .font(.title)
            
            Text("Email: \(user.email)")
                .foregroundColor(.secondary)
            
            Text("Phone: \(user.phone)")
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .navigationTitle("User Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserDetailView(user: User(
                id: "123",
                firstName: "John",
                lastName: "Doe",
                email: "john.doe@example.com",
                phone: "+1 (555) 123-4567",
                pictureURL: "https://randomuser.me/api/portraits/med/men/75.jpg"
            ))
        }
    }
}
