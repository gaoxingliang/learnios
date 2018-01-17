//
//  MusicViewController.swift
//  SwiftWeather
//
//  Created by edward.gao on 16/12/2017.
//  Copyright © 2017 Jake Lin. All rights reserved.
//

import UIKit
import AVFoundation
// 播放音乐
class MusicViewController: UIViewController , AVAudioPlayerDelegate{

    var currentSongIndex = -1
    var allSongs = Array<Song>()
    
    // audio player
    var audioPlayer: AVAudioPlayer?
    var isplaying = false
    let group = DispatchGroup()

    @IBOutlet weak var startOrStopButton: UIButton!
    
    @IBOutlet weak var musicImg: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    //IBAS
    @IBAction func nextSong(_ sender: Any) {
        stopSong()
        currentSongIndex = (currentSongIndex + 1) % allSongs.count;
        startSong()
    }
    @IBAction func prevSong(_ sender: Any) {
        stopSong()
        currentSongIndex = currentSongIndex == 0 ? allSongs.count - 1 :(currentSongIndex - 1) % allSongs.count;
        startSong()
    }
    
    @IBAction func clickedStartOrStop(_ sender: Any) {
        print("Button clicked current status is - \(isplaying)")
        
        if (isplaying) {
            stopSong()
        }
        else {
            startSong()
        }
        print("Clickk processing finished")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.startOrStopButton.addTarget(self, action: #selector(MusicViewController.clickedStartOrStop(_:)), for: UIControlEvents.touchUpInside)
        
        // Do any additional setup after loading the view.
        allSongs = getAllSongsNames()
        startSong();
        
        // back to main
        let swiperight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(WeatherViewController.swiperight(gestureRecognizer:)))
        swiperight.direction = .right
        self.view!.addGestureRecognizer(swiperight)
        
    }
    
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // https://stackoverflow.com/questions/34865212/how-to-play-the-next-song-in-tableview-automatically-when-first-song-finish
        // 自动播放下一曲
        nextSong(self)
    }
    
    @objc func swiperight(gestureRecognizer: UISwipeGestureRecognizer) {
        stopSong()
        audioPlayer?.stop()
        
        self.performSegue(withIdentifier: "music2Main", sender: gestureRecognizer)
        
    }

    
    func updateSongName (songName : String!) {
        
        DispatchQueue.main.async { [unowned self] in
            self.songNameLabel.text = songName
            self.songNameLabel.setNeedsDisplay()
        }
    }
    
    func updateArtImageView(song : Song) {
        let img = extractArtImageIfPossible(song:song)
        if img != nil {
            DispatchQueue.main.async { [unowned self] in
                self.musicImg.image = img
                self.musicImg.setNeedsDisplay()
            }
        }
    }
    
    func startSong() {
        if  isplaying == false {
            if currentSongIndex == -1 {
                // no songs here
                currentSongIndex = 0;
            }
            let currentSong = allSongs[currentSongIndex]
            
            playSongWith(audioSourceURL: currentSong.songUrl)
            updateSongName(songName: currentSong.songName)
            updateImage(start: false)
            updateArtImageView(song: currentSong)
            isplaying = true
            
        }
        else {
            // do nothing....
            if audioPlayer!.isPlaying {
                // do nothing
            } else {
                audioPlayer!.play()
            }
        }
    }
    
    func updateImage(start : Bool) {
        print("update image \(start)")
        if start {
            DispatchQueue.main.async { [unowned self] in
                self.startOrStopButton.imageView!.image = #imageLiteral(resourceName: "play")
                self.startOrStopButton.imageView!.setNeedsDisplay()
                 print(" image should be star...")
            }
        }
        else {
            DispatchQueue.main.async { [unowned self] in
                self.startOrStopButton.imageView!.image = #imageLiteral(resourceName: "pause")
                self.startOrStopButton.imageView!.setNeedsDisplay()
                 print(" image should be stop...")
            }
        }
    }
    
    // 提取相册 如果可行的话 https://stackoverflow.com/questions/33409795/how-to-get-mp3-files-artwork-in-swiftimportant-because-the-objectc-method-does
    func extractArtImageIfPossible(song : Song) -> UIImage? {
        //var artworkData: NSData = NSData()
        let asset = AVURLAsset(url: song.songUrl)
        for metadata in asset.metadata {
            if metadata.commonKey != nil {
                if let keySpace = metadata.keySpace {
                    if keySpace == AVMetadataKeySpace.iTunes {
                        print("keyspace == AVMetadataKeySpaceiTunes")
                        //artworkData = (metadata.value?.copy(with:nil))! as! NSData
                    } else {
                        if let data = metadata.dataValue {
                            let image = UIImage(data: data)
                            return image
                        }
                    }
                }
            }
        }
       
        return nil
    }
    
    
    
    func stopSong() {
        isplaying = false
        audioPlayer?.pause()
        audioPlayer?.currentTime = 0
        // change the image view
        updateImage(start: true)
    }
    
    

    
    // play song
    func playSongWith(audioSourceURL: URL!) -> Void{
            do {
                audioPlayer = try AVAudioPlayer.init(contentsOf: audioSourceURL!)
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
                audioPlayer?.delegate = self
                print("play song....")
            } catch {
                print(error)
            }
        
    }

    func getAllSongsNames() -> Array<Song> {
        
        var songs = Array<Song>()
        
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        do {
            let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for song in songPath {
                let mySongPath = song.absoluteString
                if mySongPath.contains(".mp3") {
                    
                    let findString = mySongPath.split(separator: "/")
                    let mySong = String(findString[findString.count - 1])
                    let nsString = mySong as NSString // 陈一发儿-童话镇.mp3
                    print(nsString.removingPercentEncoding!)
                    //nsString = nsString.removingPercentEncoding!
                    let musicSongNameWithEnds =  nsString.removingPercentEncoding!
                    let range = musicSongNameWithEnds.range(of:".mp3")
                    let index = range!.lowerBound
                    let subStr = String(musicSongNameWithEnds[..<index])
                    print("The song name is " + subStr)
                    let songObj = Song(songAbsPath:mySongPath , songName: subStr, songUrl: song.absoluteURL)
                    songs.append(songObj)
                    
                }
                
                
            }
        } catch {
            print(error)
        }
        return songs;
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
