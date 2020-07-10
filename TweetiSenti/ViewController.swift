//
//  ViewController.swift
//  TweetiSenti
//
//  Created by Devesh Tyagi on 10/07/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {
    
    @IBOutlet weak var textField : UITextField!
    @IBOutlet weak var sentimentLabel : UILabel!
    
    let swifter = Swifter(consumerKey: "j4b2p7t8V5O9SOwoTg3cVTPSE", consumerSecret: "bMD2Vv3Is2bJq1kgFcuijp3KTpg6iHqWcvY8KSAhqkOU3Y8FuR")
    let sentimentClassifier = TweetSentimentClassifier()
    
    let tweetCount = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func predictPressed(_ sender: Any){
        
        fetchTweet()
    }
    func fetchTweet(){
        if let searchText = textField.text{
            swifter.searchTweet(using: searchText, lang: "en",count: tweetCount,tweetMode: .extended, success: { (result, metadata) in
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<self.tweetCount{
                    if let tweet = result[i]["full_text"].string{
                        let tweetForPrediction = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForPrediction)
                    }
                }
                self.makePrediction(with : tweets)
                
                
            }) { (error) in
                print("there is an error with twitter api request ,\(error)")
                
            }
            
            
        }
        
    }
    
    func makePrediction(with tweets:[TweetSentimentClassifierInput]){
        do{
            let pridictions =  try self.sentimentClassifier.predictions(inputs: tweets)
            
            var sentimentScore = 0
            
            for pred in pridictions{
                let sentiment = pred.label
                
                if(sentiment == "Pos"){
                    sentimentScore += 1
                }else if(sentiment == "neg"){
                    sentimentScore -= 1
                }
            }
            
            
            updateUI(with: sentimentScore)
        }catch{
            print("there is an error while pridicting,\(error)")
        }
        
        
    }
    
    func updateUI(with sentimentScore: Int ){
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😀"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "🙂"
        } else if sentimentScore == 0 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "😕"
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
        
        
    }
    
    
}

