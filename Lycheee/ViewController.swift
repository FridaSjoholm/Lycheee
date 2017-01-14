//
//  ViewController.swift
//  Lycheee
//
//  Created by Frida Sjoholm on 1/12/17.
//  Copyright © 2017 Frida Sjoholm. All rights reserved.
//

import UIKit

func makeRequest(request: URLRequest, completion: @escaping (String)->Void) {

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
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print(json)
        } catch {
            print("error serializing JSON: \(error)")
        }
        let responseString = String(data: data, encoding: .utf8) ?? ""
        completion(responseString)
    }
    task.resume()
}

class ViewController: UIViewController {
    
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var txtOutput: UITextView!
    
    var items:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func findToy(_ sender: Any)  {
        if(txtInput.text == ""){
            return
        }
        items.append(txtInput.text!)
        txtOutput.text = ""
        
        for item in items {
            txtOutput.text.append("*  \(item)\n")
        }
        txtInput.text = ""
        txtInput.resignFirstResponder()
        
        makeRequest(request: URLRequest(url: URL(string: "https://salty-headland-39270.herokuapp.com/pets/2/toys.json")!)) {response in
            print(response)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

