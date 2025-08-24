//
//  ReviewCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 22.07.2022.
//

import Foundation
import UIKit

class ReviewCellView: UITableViewCell {
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet var reviewMarkView: [ReviewMarkView]!
    
    var textAction: ((String) -> ())?
    var action: ((ReviewRateType, Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.f2f2f2
        self.commentTextView.layer.cornerRadius = 20
        self.commentTextView.layer.borderWidth = 1
        self.commentTextView.layer.borderColor = Colors.e3e3e3.cgColor
        self.commentTextView.textContainerInset =  UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        self.commentTextView.tintColor = Colors.main
        self.commentTextView.text = "Ваш комментарий (опционально)"
        self.commentTextView.textColor = Colors.gray
        self.commentTextView.font = Fonts.regular(size: 12)
        self.commentTextView.delegate = self
        self.commentTextView.addReadyButton()
    }
    
    func setupModel(_ model: ReviewOutputModel) {
        for (index,markView) in self.reviewMarkView.enumerated() {
            markView.setupModel(model: model.marks[index])
            markView.action = { [unowned self] type, rate in
                self.action?(type, rate)
            }
        }
        if let comment = model.comment {
            self.commentTextView.text = comment
        }
    }
    
}

extension ReviewCellView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.textAction?(textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Colors.gray {
            textView.text = nil
            textView.textColor = Colors.mainBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Ваш комментарий (опционально)"
            textView.textColor = Colors.gray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 255
    }
}
