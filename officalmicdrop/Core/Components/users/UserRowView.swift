//
//  UserRowView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 5/26/23.
//

import SwiftUI
import Kingfisher

struct UserRowView: View {
    let user: User
    var body: some View {
        HStack(spacing: 12) {
            KFImage(URL(string: user.profileImageUrl))
                
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 56, height: 56)
            VStack(alignment: .leading, spacing: 4) {
                Text(user.username)
                    .font(.subheadline).bold()
                    .foregroundColor(.black)
                Text(user.hashtags.joined(separator: ", "))
                    .font(.footnote)
                    .foregroundColor(.gray)

            

            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
}

//struct UserRowView_Previews: PreviewProvider {
  //  static var previews: some View {
   //     UserRowView()
  //  }
//}
