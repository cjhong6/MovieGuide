//
//  MovieDetailController.swift
//  MovieGuide
//
//  Created by Chengjiu Hong on 11/3/16.
//  Copyright © 2016 Chengjiu Hong. All rights reserved.
//

import UIKit
import AlamofireImage
import AVFoundation

//Store state of the speech Uterrance for pause/play functionality
struct TextToSpeech {
    static var pausing: Bool? = true
    static var previousIndex: NSIndexPath = NSIndexPath()
}

class MovieDetailController: UIViewController {
    // text-to-speech code
    let speechSynthesizer = AVSpeechSynthesizer()
    var rate: Float!
    var pitch: Float!
    var volume: Float!
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBAction func playButton(_ sender: Any) {
        let text = overviewLabel.text
        let speechUtterance = AVSpeechUtterance(string: text!)
        speechUtterance.rate = rate
        speechUtterance.pitchMultiplier = pitch
        speechUtterance.volume = volume
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        print(speechUtterance)
        speechSynthesizer.speak(speechUtterance)
    }
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = movie?.movieTitle
        
        self.overviewLabel.text = movie?.movieOverview
        
        if(movie?.movieBackdropPathUrl != nil) {
            backdropImageView.af_setImage(withURL: URL(string: (movie?.movieBackdropPathUrl!)!)!)
        }

        //Text-to-Speech settings
        if !loadSettings() {
            registerDefaultSettings()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //Text-to-Speech default settings
    func registerDefaultSettings() {
        rate = AVSpeechUtteranceDefaultSpeechRate
        pitch = 1.0
        volume = 1.0
        
        let defaultSpeechSettings: Dictionary<String, AnyObject> = ["rate": rate as AnyObject, "pitch": pitch as AnyObject, "volume": volume as AnyObject]
        UserDefaults.standard.register(defaults: defaultSpeechSettings)
    }
    
    //load Text-to-Speech default settings
    func loadSettings() -> Bool {
        let userDefaults = UserDefaults.standard
        if let theRate: Float = userDefaults.value(forKey: "rate") as? Float {
            rate = theRate
            pitch = userDefaults.value(forKey: "pitch") as! Float
            volume = userDefaults.value(forKey: "volume") as! Float
            return true
        }
        return false
    }
    
    //stop the speaking once this view disappear
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        if (self.isMovingFromParentViewController){
            speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
    }

}
