//
//  ViewController.swift
//  XAudioPlayer
//  a simple demo :https://www.youtube.com/watch?v=7CdnxxgQ3Sw
//  Created by edward.gao on 16/12/2017.
//  Copyright © 2017 edward.gao. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // audio player
    var audioPlayer: AVAudioPlayer!
    var curAudio: String?
    
    // play song
    func playSongWith(fileName: String, fileExetension: String) -> Void{
        let audioSourceURL: URL!
        audioSourceURL = Bundle.main.url(forResource: fileName, withExtension: fileExetension)
        if audioSourceURL == nil {
            print("Resource not found - " + fileName)
        } else {
            do {
                audioPlayer = try AVAudioPlayer.init(contentsOf: audioSourceURL!)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                print("play it now \(fileName)")
            } catch {
                print(error)
            }
        }
    }
    
    
    func getAllSongs() {
        // research all
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        
        do {
            let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for song in songPath {
                var mySong = song.absoluteString
                if mySong.contains(".mp3") {
                    print("Abspath :" + mySong)
                    let findString = mySong.split(separator: "/")
                    
                    print("True file name \(findString[findString.count - 1])")
                    mySong = String(findString[findString.count - 1])
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    let nsString = mySong as NSString
                    print(nsString.removingPercentEncoding)
                }
            }
        } catch {
            print(error)
        }
    }
    
    
    //IBActions
    
    @IBAction func playButton(_ sender: UIButton, forEvent event: UIEvent) {
        if (curAudio == nil) {
            
            
        }
        playSongWith(fileName: "Soler-风的季节", fileExetension: "mp3")
    }
    
    
    @IBAction func pauseButton(_ sender: Any) {
        audioPlayer.pause()
        print("song paused")
    }
    
    @IBAction func resetAction(_ sender: Any) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        print("song stopp...")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getAllSongs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

