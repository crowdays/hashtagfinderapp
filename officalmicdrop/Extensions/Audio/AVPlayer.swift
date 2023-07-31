//
//  AVPlayer.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/13/23.
//

import SwiftUI
import AVFoundation

struct PlayerView: View {
    @StateObject private var player = AVPlayerWrapper()
    @State private var sliderValue: Double = 0.0

    var audioURL: URL

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    player.isPlaying ? player.pause() : player.play()
                }) {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(Color(.black))
                        .padding()
                }
                
                Slider(value: $sliderValue, in: 0...1, onEditingChanged: sliderEditingChanged)
                    .accentColor(Color(red: 1.00, green: 0.84, blue: 0.00))  // RGB for Gold

                    
            }
        }
        .onAppear {
            player.setupPlayer(url: audioURL)
        }
        .onReceive(player.$playbackProgress) { progress in
            sliderValue = progress
        }
    }
    
    func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            player.pause()
        } else {
            player.seek(to: sliderValue)
        }
    }
}

class AVPlayerWrapper: ObservableObject {
    private var player: AVPlayer!

    @Published var isPlaying = false
    @Published var playbackProgress: Double = 0.0

    func setupPlayer(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // Update playback progress
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self, let duration = self.player.currentItem?.duration else { return }
            self.playbackProgress = time.seconds / duration.seconds
        }
    }

    func play() {
        player.play()
        isPlaying = true
    }

    func pause() {
        player.pause()
        isPlaying = false
    }
    
    func seek(to percentage: Double) {
        guard let duration = player.currentItem?.duration else { return }
        let newTime = duration.seconds * percentage
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        play()
    }
}


