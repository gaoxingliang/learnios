//
//  MainViewController.swift
//  SwiftWeather
//
//  Created by edward.gao on 11/12/2017.
//  Copyright © 2017 Jake Lin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var weatherImgView: UIImageView!
    
    @IBOutlet weak var musicPlayerImgView: UIImageView!
    
    @IBOutlet weak var alarmImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Do any additional setup after loading the view.
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(MainViewController.weatherTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.weatherImgView.addGestureRecognizer(tapGesture)
        self.weatherImgView.isUserInteractionEnabled = true
        
        
        
        let tapGestureForMusic=UITapGestureRecognizer(target: self, action: #selector(MainViewController.musicTapped(_:)))
        tapGestureForMusic.numberOfTapsRequired = 1
        tapGestureForMusic.numberOfTouchesRequired = 1
        self.musicPlayerImgView.addGestureRecognizer(tapGestureForMusic)
        self.musicPlayerImgView.isUserInteractionEnabled = true
        
        
        
        let tapGestureForAlarm=UITapGestureRecognizer(target: self, action: #selector(MainViewController.alarmTapped(_:)))
        tapGestureForAlarm.numberOfTapsRequired = 1
        tapGestureForAlarm.numberOfTouchesRequired = 1
        self.alarmImgView.addGestureRecognizer(tapGestureForAlarm)
        self.alarmImgView.isUserInteractionEnabled = true
        
    }
    
    
    @objc func alarmTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "main2Alarm", sender: sender)
    }
    
    
    @objc func musicTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "main2Music", sender: sender)
    }
    
    @objc func weatherTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "main2Weather", sender: sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
