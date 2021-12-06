//
//  FAQViewController.swift
//  FFTeach
//
//  Created by Sean Levine on 12/3/21.
//

import UIKit

class FAQViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = "https://github.com/Seanmlevine/FFTeach"
        let text = "Link to our GitHub"
        let attributedString = NSAttributedString.makeHyperlink(for: path, in: text, as: "Link to our GitHub")
        
        let items = [FAQItem(question: "What is reddit?", answer: "reddit is a source for what's new and popular on the web."),
                     FAQItem(question: "How is a submission's score determined?", answer: "A submission's score is simply the number of upvotes minus the number of downvotes."), FAQItem(question: "Where can I find your code?", attributedAnswer: attributedString)]
            

        let faqView = FAQView(frame: view.frame, title: "FAQs", items: items)
        view.addSubview(faqView)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
