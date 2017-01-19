//
//  ViewController.swift
//  Lycheee
//
//  Created by Frida Sjoholm on 1/12/17.
//  Copyright © 2017 Frida Sjoholm. All rights reserved.
//

import UIKit

func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}

func makeRequest(param: String, request: URLRequest, completion: @escaping ([String])->Void) {
    var req = request
    req.addValue("application/json", forHTTPHeaderField: "Accept")
    var info:[String] = []
    var youtubes:[String] = []
    let task = URLSession.shared.dataTask(with: req) {data, response, error in
        guard let data = data, error == nil else{
            print("error=\(error)")
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(response)")
        }
        do {
            let json = try? JSONSerialization.jsonObject(with: data)
            if let array = json as? [Any] {
                for object in array {
                    if let dictionary = object as? [String: Any] {
                        if let track_youtube_id_obj = dictionary["track_youtube_id"] as? String {
                            youtubes.append(track_youtube_id_obj)
                            if let title_obj = dictionary["title"] as? String {
                                if let artist_obj = dictionary["artist_name"] as? String {
                                    info.append("\(artist_obj) - \(title_obj)")
                                }
                            }
                        }
                    }
                }
            }
        }
        print(youtubes)
        completion(youtubes)
    }
    task.resume()
}
class ViewController: UIViewController {
    
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var youtubeView: UIWebView!
    @IBOutlet weak var wordView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image: UIImage = UIImage(named: "LClogo")!
        let imageView = UIImageView(image: image)
        self.view.addSubview(imageView)
        imageView.frame = CGRectMake(0,self.view.frame.height * 0.1,self.view.frame.width,self.view.frame.height * 0.23)
    }
    
    var youtubies:[String] = []
    var counter = 0
    
    @IBAction func findToy(_ sender: Any)  {
        self.youtubies.removeAll()
        if(txtInput.text == ""){
            return
        }
        let word = txtInput.text
        let wordstring =  "Showing songs about " + word!
        wordView.text = wordstring
        let uword =  word?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = "https://lyricallychallenged.herokuapp.com/search?word="
        let total = url + uword!
        txtInput.text = ""
        txtInput.resignFirstResponder()
        var youtubeurl = "https://www.youtube.com/embed/"
        
        makeRequest(param: word!, request: URLRequest(url: URL(string: total)!)) {response in
            for resp in response{
                DispatchQueue.main.async {
                    self.counter = 0
                    self.youtubies.append(resp)
                }
            }
            DispatchQueue.main.async(execute: {
                youtubeurl.append(self.youtubies[self.counter])
                print(self.youtubies[self.counter])
                print(youtubeurl)
                let myURLRequest : URLRequest =  URLRequest(url: URL(string: youtubeurl)!)
                self.youtubeView.loadRequest(myURLRequest)
            })

        }
    }
    @IBAction func nextTrack(_ sender: Any) {
        DispatchQueue.main.async {
            self.counter += 1
            if self.counter == self.youtubies.count{
                print(self.counter)
                self.counter = 0
            }else{
                var youtubeurl = "https://www.youtube.com/embed/"
                youtubeurl.append(self.youtubies[self.counter])
                let myURLRequest : URLRequest =  URLRequest(url: URL(string: youtubeurl)!)
                self.youtubeView.loadRequest(myURLRequest)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

