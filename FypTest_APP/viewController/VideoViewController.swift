//
//  VideoViewController.swift
//  FypTest_APP

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {
    
    var videoName: String!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getVideo(self.videoName)
    }
    
    func getVideo(_ videoName: String) {
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "\(videoName)", ofType: "MOV")!))
        
        let layer = AVPlayerLayer(player: player)
        layer.frame = view.bounds
        view.layer.addSublayer(layer)
        player.volume = 0
        player.play()
    }

}
