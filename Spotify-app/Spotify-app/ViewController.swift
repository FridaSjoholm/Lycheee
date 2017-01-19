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
                        if let title_obj = dictionary["title"] as? String {
                            if let artist_obj = dictionary["artist_name"] as? String {
                                info.append("\(artist_obj) - \(title_obj)")
                            }
                        }
                    }
                }
            }
        }
        completion(info)
    }
    task.resume()
}
class ViewController: UIViewController {

    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var txtOutput: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let image: UIImage = UIImage(named: "LClogo")!
        let imageView = UIImageView(image: image)
        self.view.addSubview(imageView)
        imageView.frame = CGRectMake(0,0,self.view.frame.width,self.view.frame.height * 0.23)

    }
    @IBAction func findToy(_ sender: Any)  {
        if(txtInput.text == ""){
            return
        }
        txtOutput.text = ""
        let word = txtInput.text
        let uword =  word?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = "https://lyricallychallenged.herokuapp.com/search?word="
        let total = url + uword!
        txtInput.text = ""
        txtInput.resignFirstResponder()
 
        makeRequest(param: word!, request: URLRequest(url: URL(string: total)!)) {response in
            for resp in response {
                DispatchQueue.main.async {
                    self.txtOutput.text.append("\(resp)\n")
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

