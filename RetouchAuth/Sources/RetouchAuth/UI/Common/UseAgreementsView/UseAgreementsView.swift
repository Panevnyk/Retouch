import SwiftUI

@MainActor
public protocol UseAgreementsDelegate: AnyObject {
    func didSelectPrivacyPolicy()
    func didSelectTermsOfUse()
}

public struct UseAgreementsView: View {
    private let delegate: UseAgreementsDelegate?
    private let isLightStyle: Bool

    private static let privacyPolicyURL = "https://www.google.com"
    private static let termsOfUseURL = "https://www.apple.com"

    public init(
        delegate: UseAgreementsDelegate?,
        isLightStyle: Bool = false
    ) {
        self.delegate = delegate
        self.isLightStyle = isLightStyle
    }

    public var body: some View {
        Text(buildAttributedString())
            .font(.kPlainText)
            .multilineTextAlignment(.center)
            .foregroundColor(isLightStyle ? .white : .kTextMiddleGray)
            .tint(isLightStyle ? .white : .kPurple)
            .onOpenURL { url in
                if url.absoluteString == Self.privacyPolicyURL {
                    delegate?.didSelectPrivacyPolicy()
                } else if url.absoluteString == Self.termsOfUseURL {
                    delegate?.didSelectTermsOfUse()
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
    }

    private func buildAttributedString() -> AttributedString {
        var result = AttributedString("By continuing to use RetouchYou App, you agree to our\n")
        result.foregroundColor = isLightStyle ? .white : .kTextMiddleGray

        var privacy = AttributedString("Privacy Policy")
        privacy.link = URL(string: Self.privacyPolicyURL)
        privacy.underlineStyle = .single
        privacy.foregroundColor = isLightStyle ? .white : .kPurple
        privacy.font = .custom("kDescriptionMediumText", size: 14)

        var and = AttributedString(" and ")
        and.foregroundColor = isLightStyle ? .white : .kTextMiddleGray

        var terms = AttributedString("Terms of Use")
        terms.link = URL(string: Self.termsOfUseURL)
        terms.underlineStyle = .single
        terms.foregroundColor = isLightStyle ? .white : .kPurple
        terms.font = .custom("kDescriptionMediumText", size: 14)

        result.append(privacy)
        result.append(and)
        result.append(terms)

        return result
    }
}
