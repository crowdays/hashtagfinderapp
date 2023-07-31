//
//  WaveformView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/18/23.
//

import SwiftUI

struct WaveformView: View {
    var levels: [CGFloat] // This array represents the audio levels

    var body: some View {
        HStack(spacing: 4) {
            ForEach(levels, id: \.self) { level in
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 2, height: level)
            }
        }
    }
}


//struct WaveformView_Previews: PreviewProvider {
  //  static var previews: some View {
    //    WaveformView()
    //}
//}
