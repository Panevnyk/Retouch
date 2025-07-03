import UIKit
import RetouchUtils
import RetouchDesignSystem
import FactoryKit

@objc(ExamplesTableViewCell)
final class ExamplesTableViewCell: UITableViewCell {
    @Injected(\.imageLoader) var imageLoader

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.kSeparatorGray.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let exampleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let exampleTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .kTitleBigText
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let exampleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .kPlainText
        label.textColor = .kGrayText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubview(exampleImageView)
        containerView.addSubview(exampleTitleLabel)
        containerView.addSubview(exampleDescriptionLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            exampleImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 13),
            exampleImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 13),
            exampleImageView.widthAnchor.constraint(equalToConstant: 84),
            exampleImageView.heightAnchor.constraint(equalToConstant: 84),

            exampleTitleLabel.leadingAnchor.constraint(equalTo: exampleImageView.trailingAnchor, constant: 13),
            exampleTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 19),
            exampleTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -13),

            exampleDescriptionLabel.topAnchor.constraint(equalTo: exampleTitleLabel.bottomAnchor, constant: 13),
            exampleDescriptionLabel.leadingAnchor.constraint(equalTo: exampleImageView.trailingAnchor, constant: 13),
            exampleDescriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -13),
            exampleDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -13)
        ])
    }

    // MARK: - Public
    func fill(viewModel: ExampleItemViewModelProtocol) {
        exampleTitleLabel.text = viewModel.title
        exampleDescriptionLabel.text = viewModel.description
        if let url = URL(string: viewModel.imageAfter) {
            imageLoader.setImage(to: exampleImageView, from: url)
        }
    }
}
