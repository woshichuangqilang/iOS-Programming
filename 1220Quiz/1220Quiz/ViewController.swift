//
//  ViewController.swift
//  1220Quiz
//
//  Created by Wenslow on 15/12/20.
//  Copyright © 2015年 Wenslow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var currentQuestionLabel: UILabel!
    @IBOutlet var currentQuestionLabelCententXConstraint: NSLayoutConstraint!
    
    @IBOutlet var nextQuestionLabel: UILabel!
    @IBOutlet var nextQuestionLabelCententXConstraint: NSLayoutConstraint!
    
//    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var currentAnswerLabel: UILabel!
    @IBOutlet var currentAnswerLabelCententXConstraint: NSLayoutConstraint!
    
    @IBOutlet var nextAnswerLabel:UILabel!
    @IBOutlet var nextAnswerLabelCententXConstraint: NSLayoutConstraint!
    
    
    let questions: [String] = ["From what is congnac made?", "What is 7 + 7", "What is the capital of Vermont?"]
    let answers:[String] = ["Grapes", "14", "Montpelier"]
    var currentQuestionIndex:Int = 0
    
    @IBAction func showNextQuestion(sender: UIButton) {
        ++currentQuestionIndex
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        let question:String = questions[currentQuestionIndex]
//        questionLabel.text = question
        nextQuestionLabel.text = question
        
//        answerLabel.text = "???"
        currentAnswerLabel.alpha = 1
        currentAnswerLabel.text = "???"
        
        animateLabelTransitions()
    }
    
    @IBAction func showAnswer(sender: UIButton) {
        let answer: String = answers[currentQuestionIndex]
        nextAnswerLabel.text = answer
        
        animateLabelTransitionsOfAnswerLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        questionLabel.text = questions[currentQuestionIndex]
        
        let question = questions[currentQuestionIndex]
        currentQuestionLabel.text = question
        
        updateOffScreenLabel()
        // Do any additional setup after loading the view, typically from a nib.
    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Set the label's initial alpha
//        questionLabel.alpha = 0
        
        currentQuestionLabel.alpha = 0
        nextQuestionLabel.alpha = 0
        
        currentAnswerLabel.alpha = 0
        nextAnswerLabel.alpha = 0
    }
    
    func animateLabelTransitions() {
//        let animationClosure = { () -> Void in
//            self.questionLabel.alpha = 1
//        }
        //alpha 动画
//        UIView.animateWithDuration(0.5, animations: animationClosure)
        
//        UIView.animateWithDuration(0.5, animations: {
////            self.questionLabel.alpha = 1
//            self.currentQuestionLabel.alpha = 0
//            self.nextQuestionLabel.alpha = 1
//        })
        
        //Force any outstanding layout changes to occur
        view.layoutIfNeeded()
        
        // and the center X constraints
        let screenWidth = view.frame.width
        self.nextQuestionLabelCententXConstraint.constant = 0
        self.currentQuestionLabelCententXConstraint.constant += screenWidth
        
        UIView.animateWithDuration(0.5,
            delay: 0,
            options: [.CurveEaseOut],
            animations: {
            self.currentQuestionLabel.alpha = 0
            self.nextQuestionLabel.alpha = 1
                
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
                swap(&self.currentQuestionLabelCententXConstraint, &self.nextQuestionLabelCententXConstraint)
                
                self.updateOffScreenLabel()
        })
    }
    
    func animateLabelTransitionsOfAnswerLabel() {
        view.layoutIfNeeded()
        
        // and the center X constraints
        let screenWidth = view.frame.width
        self.nextAnswerLabelCententXConstraint.constant = 0
        self.currentAnswerLabelCententXConstraint.constant += screenWidth
        
//        UIView.animateWithDuration(0.5,
//            delay: 0,
//            options: [.CurveEaseOut],
//            animations: {
//                self.currentAnswerLabel.alpha = 0
//                self.nextAnswerLabel.alpha = 1
//                
//                self.view.layoutIfNeeded()
//            },
//            completion: { _ in
//                swap(&self.currentAnswerLabel, &self.nextAnswerLabel)
//                swap(&self.currentAnswerLabelCententXConstraint, &self.nextAnswerLabelCententXConstraint)
//                
//                self.updateOffScreenLabelOfAnswerLabel()
//        })
        
        UIView.animateWithDuration(0.5,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [.CurveEaseOut],
            animations: {
                self.currentAnswerLabel.alpha = 0
                self.nextAnswerLabel.alpha = 1
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                swap(&self.currentAnswerLabel, &self.nextAnswerLabel)
                swap(&self.currentAnswerLabelCententXConstraint, &self.nextAnswerLabelCententXConstraint)
                self.updateOffScreenLabelOfAnswerLabel()
                
        })

    }
    
    func updateOffScreenLabel() {
        let screenWidth = view.frame.width
        nextQuestionLabelCententXConstraint.constant = -screenWidth
        
    }
    
    func updateOffScreenLabelOfAnswerLabel() {
        let screenWidth = view.frame.width
        nextAnswerLabelCententXConstraint.constant = -screenWidth
        
    }
    
}

