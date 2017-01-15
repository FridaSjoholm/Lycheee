//
//  ViewController.swift
//  Lycheee
//
//  Created by Frida Sjoholm on 1/12/17.
//  Copyright © 2017 Frida Sjoholm. All rights reserved.
//

import UIKit

func makeRequest(request: URLRequest, completion: @escaping ([String])->Void) {
    var desc:[String] = []
    let task = URLSession.shared.dataTask(with: request) {data, response, error in
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
                        if let description = dictionary["description"] as? String {
                            desc.append(description)
                        }
                    }
                }
            }
            
        } catch {
            print("error serializing JSON: \(error)")
        }
        completion(desc)
    }
    task.resume()
}
class ViewController: UIViewController {
    
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var txtOutput: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func findToy(_ sender: Any)  {
        if(txtInput.text == ""){
            return
        }
        txtOutput.text = ""
        txtInput.text = ""
        txtInput.resignFirstResponder()
        
        makeRequest(request: URLRequest(url: URL(string: "https://salty-headland-39270.herokuapp.com/pets/2/toys.json")!)) {response in
            for resp in response {
                DispatchQueue.main.async {
                    self.txtOutput.text.append("*  \(resp)\n")
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

