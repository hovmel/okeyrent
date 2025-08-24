//
//  ReviewController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 21.07.2022.
//

import Foundation
import UIKit

enum ReviewControllerCellType {
    case object(ObjectModel)
    case review(ReviewOutputModel)
}

class ReviewController: KeyboardController {
    
    class func openReviewController(viewController: UIViewController, object: ObjectModel) {
        let storyboard = UIStoryboard(name: "Review", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? []
        let reviewController = storyboard.instantiateInitialViewController() as! ReviewController
        reviewController.viewModel = ReviewViewModel(view: reviewController, object: object)
        controllers.append(reviewController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionButton: CommonButton!
    
    var sections: [ReviewControllerCellType] {
        return [.object(self.viewModel.object),
                .review(self.viewModel.model)]
    }
    
    var viewModel: ReviewViewModel!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.commonSetup()
        self.commonTableViewSetup(tableView: self.tableView, cells: [ObjectShortCellView.self,
                                                                     ReviewCellView.self])
        self.tableView.separatorStyle = .singleLine
        self.actionButton.isEnabled = false
        self.title = "Оставить отзыв" 
    }
    
    override func hideTap() {}
    
    override func changeKeyboardHeight(_ keyboardHeight: CGFloat) {
        self.tableView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 0,
                                                   bottom: keyboardHeight,
                                                   right: 0)
    }
    
    @IBAction func actionPressed() {
        self.viewModel.sendReview()
    }
    
}

extension ReviewController: ReviewView {
    
    func setupButtonEnabled(_ isEnabled: Bool) {
        self.actionButton.isEnabled = isEnabled
    }
    
    func setupLoading(_ isLoading: Bool) {
        self.actionButton.setupLoading(isLoading)
    }
    
    func error(_ message: String) {
        self.openErrorAlert(message: message)
    }
    
    func openSuccess() {
        self.openInfoAlert(title: "Отзыв успешно отправлен", rightAction: { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}

extension ReviewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.row]
        switch section {
        case .object(let model):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectShortCellView.self), for: indexPath) as? ObjectShortCellView {
                cell.setupModel(model)
                return cell
            }
        case .review(let model):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReviewCellView.self), for: indexPath) as? ReviewCellView {
                cell.setupModel(model)
                cell.textAction = { [unowned self] text in
                    self.viewModel.model.comment = text
                }
                cell.action = { [unowned self] type, rate in
                    self.viewModel.setMark(type: type, rate: rate)
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
