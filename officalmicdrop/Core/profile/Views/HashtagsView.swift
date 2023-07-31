//
//  HashtagsView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/5/23.
//

import SwiftUI

struct HashtagsView: View {
    let hashtags: [String]
    
    var body: some View {
        List {
            ForEach(hashtags, id: \.self) { hashtag in
                Text("#\(hashtag)")
            }
        }
    }
}


struct HashtagsView_Previews: PreviewProvider {
    static var previews: some View {
        HashtagsView(hashtags: ["example", "preview", "hashtags"])
    }
}

