//
//  SmallRatingView.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 05.05.2021.
//

import UIKit

public protocol SmallRatingViewDelegate: AnyObject {
    func didTapRating(from view: SmallRatingView)
}

@objc(SmallRatingView)
public final class SmallRatingView: BaseCustomView {
    // MARK: - Properties
    @IBOutlet private var xibView: BaseTapableView!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var ratingImageView: UIImageView!
    
    public weak var delegate: SmallRatingViewDelegate?
    
    // MARK: - initialize
    public override func initialize() {
        addSelfNibUsingConstraints(bundle: Bundle.module)
        
        ratingLabel.textColor = .black
        ratingLabel.font = .kPlainBigText
        xibView.delegate = self
    }
    
    public func setRating(_ rating: Int?) {
        ratingLabel.isHidden = rating == nil
        if let rating = rating {
            ratingLabel.text = String(rating)
        }
        
        let img = rating == nil ? "icStar24" : "icStar24Selected"
        ratingImageView.image = UIImage(named: img, in: Bundle.module, compatibleWith: nil)
    }
}

// MARK: - BaseTapableViewDelegate
extension SmallRatingView: BaseTapableViewDelegate {
    public func didTapAction(inView view: BaseTapableView) {
        delegate?.didTapRating(from: self)
    }
}
