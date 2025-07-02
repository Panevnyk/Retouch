import SwiftUI
import Combine
import RetouchDesignSystem

public enum TextInputValidationType {
    case onSubmit
    case onChangeCharacter
}

struct TextInput: View {
    // MARK: - PRoperties
    private let type: TextInputType
    
    @Binding private var text: String {
        willSet { oldText = text }
    }
    
    private let placeholder: String
    private var validator: ValidatorProtocol
    private var formatter: FormatterProtocol
    @State private var isValid: Bool
    @Binding private var isValidPublisher: Bool
    @Binding private var isDisabled: Bool
    @State private var isSecured: Bool = false
    private var validationType: TextInputValidationType = .onSubmit
    private var keyboardType: UIKeyboardType
    private var leftView: AnyView?
    private var rightImage: Image?
    
    // MARK: - Private properties
    @State private var error: String?
    private var isErrorTextNeeded = false
    @FocusState private var isFocusedState: Bool
    private var isFocusedForced: Bool?
    private var isFocused: Bool { isFocusedState || isFocusedForced == true }
    @State private var oldText: String = ""
    
    private var isError: Bool { !(error?.isEmpty ?? true) }
    private var isPopulated: Bool { !text.isEmpty }
    private var isPopulatedOrActive: Bool { isPopulated || isFocused }

    public init(
        type: TextInputType = .default,
        text: Binding<String>,
        placeholder: String
    ) {
        self.type = type
        self._text = text
        self.placeholder = placeholder
        self.formatter = type.formatter
        self.validator = type.validator
        self.keyboardType = type.keyboardType
        self._isDisabled = .constant(false)
        self.isValid = false
        self._isValidPublisher = .constant(false)
    }
    
    // MARK: - Body
    public var body: some View {
        VStack(alignment: .leading, spacing: Constants.stackSpacing) {
            HStack {
                ZStack(alignment: .leading) {
                    Text(isPopulatedOrActive ? placeholder.localizedUppercase : placeholder)
                        .foregroundColor(placeholderColor)
                        .font(.kPlainText)
                        .padding(.horizontal, Constants.padding)
                        .offset(y: isPopulatedOrActive ? Constants.placholderYOffset : .zero)
                        .zIndex(Constants.placeholderZIndex)
                        .animation(Constants.animation, value: isPopulatedOrActive)
                        .accessibilityHidden(true)
                    
                    HStack {
                        if let leftView {
                            leftView
                                .foregroundColor(rightImageColor)
                                .offset(y: Constants.TextInputYOffset)
                                .opacity(isPopulatedOrActive ? 1 : 0)
                                .accessibilityHidden(true)
                        }
                        
                        textField("", text: $text)
                            .onChange(of: text) {
                                onTextChange()
                            }
                            .onChange(of: isFocusedState) {
                                onFocusChange()
                            }
                            .foregroundColor(textColor)
                            .keyboardType(keyboardType)
                            .disabled(isDisabled)
                            .padding(.vertical, Constants.padding)
                            .offset(y: Constants.TextInputYOffset)
                            .focused($isFocusedState)
                            .accessibilityLabel(placeholder)
                    }
                    .padding(.leading, Constants.padding)
                }
                
                if let rightImage {
                    rightImage
                        .renderingMode(.template)
                        .foregroundColor(rightImageColor)
                        .padding(.trailing, Constants.padding)
                        .accessibilityHidden(true)
                }
            }
            .background(backgroundColor)
            .cornerRadius(Constants.TextInputBoxCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.TextInputBoxCornerRadius)
                    .stroke(borderColor, lineWidth: Constants.TextInputBoxBorderWidth)
            )
            .frame(height: Constants.TextInputBoxHeight)
            .padding(.horizontal, Constants.borderPadding)
            
            if isErrorTextNeeded, isError, !isDisabled, let error {
                Text(error)
                    .foregroundColor(.kRed)
                    .padding(.horizontal, Constants.borderPadding)
            }
        }
        .onTapGesture {
            guard !isDisabled else { return }
            isFocusedState = true
        }
    }
    
    @ViewBuilder
    private func textField(_ titleKey: LocalizedStringKey, text: Binding<String>) -> some View {
        if isSecured {
            SecureField(titleKey, text: text)
        } else {
            TextField(titleKey, text: text)
        }
    }
    
    // MARK: - Public
    /// Set two-way binding property isValid on character change into the copy of self
    public func setIsValid(_ isValid: Binding<Bool>) -> TextInput {
        var copy = self
        copy._isValidPublisher = isValid
        return copy
    }
    
    /// Set two-way binding property isDisabled into the copy of self
    public func setIsDisabled(_ isDisabled: Binding<Bool>) -> TextInput {
        var copy = self
        copy._isDisabled = isDisabled
        return copy
    }
    
    /// Should be used only for disabled TextInput. When user is not able to edit text.
    /// For example input from Dropdown option selection.
    public func setIsFocused(_ isFocused: Bool?) -> TextInput {
        var copy = self
        copy.isFocusedForced = isFocused
        copy.onFocusChange()
        return copy
    }
    
    /// Error text will be shown only if isErrorTextNeeded == true. Can be updated using:
    public func setIsErrorTextNeeded(_ isErrorTextNeeded: Bool) -> TextInput {
        var copy = self
        copy.isErrorTextNeeded = isErrorTextNeeded
        return copy
    }
    
    /// Set isSecure into the copy of self
    public func setIsSecured(_ isSecured: Bool) -> TextInput {
        var copy = self
        copy._isSecured = State(initialValue: isSecured)
        return copy
    }
    
    /// Set leftView into the copy of self
    func setLeftView(_ leftView: AnyView?) -> TextInput {
        var copy = self
        copy.leftView = leftView
        return copy
    }
    
    /// Set rightImage into the copy of self
    public func setRightImage(_ rightImage: Image?) -> TextInput {
        var copy = self
        copy.rightImage = rightImage
        return copy
    }
    
    /// Set formatter into the copy of self
    public func setFormatter(_ formatter: FormatterProtocol) -> TextInput {
        var copy = self
        copy.formatter = formatter
        return copy
    }
    
    /// Set validator into the copy of self
    public func setValidator(_ validator: ValidatorProtocol) -> TextInput {
        var copy = self
        copy.validator = validator
        return copy
    }
    
    /// Set validationType into the copy of self
    public func setValidationType(_ validationType: TextInputValidationType) -> TextInput {
        var copy = self
        copy.validationType = validationType
        return copy
    }
    
    /// Set keyboardType into the copy of self
    public func setKeyboardType(_ keyboardType: UIKeyboardType) -> TextInput {
        var copy = self
        copy.keyboardType = keyboardType
        return copy
    }
    
    /// Validate inputed text and update component state if needed
    public func validate() {
        let validationResult = validator.validate(text)
        switch validationResult {
        case .noResult, .success:
            error = nil
            
        case .error(let errorText):
            error = errorText
        }
        isValid = validationResult.isValid
    }
    
    private func updateIsValidPublisher() {
        let validationResult = validator.validate(text)
        isValidPublisher = validationResult.isValid
    }
    
    // MARK: - Private
    private func onTextChange() {
        formatText(oldText, text)
        if validationType == .onChangeCharacter || isError {
            validate()
        }
        updateIsValidPublisher()
    }
    
    private func onFocusChange() {
        if !isFocused {
            validate()
        } else {
            error = nil
        }
    }
    
    private func formatText(_ oldText: String, _ newText: String) {
        var notFormattedNewText = formatter.clean(newText)
        let notFormattedOldText = formatter.clean(oldText)
        
        if newText.count < oldText.count
            && notFormattedNewText.count >= notFormattedOldText.count {
            notFormattedNewText = String(notFormattedNewText.dropLast())
        }
        
        text = formatter.format(notFormattedNewText)
    }
}

// MARK: - Style
private extension TextInput {
    var borderColor: Color {
        if isDisabled { return .kTextDarkGray }
        else if isError { return .kDeclinedStatusRed }
        else if isFocused { return .kPurple }
        return .kTextDarkGray
    }
    
    var textColor: Color {
        if isDisabled { return .kTextDarkGray }
        return .kPurple
    }
    
    var placeholderColor: Color {
        if isDisabled { return .kTextDarkGray }
        else if isError { return .kDeclinedStatusRed }
        else if isFocused { return .kPurple }
        return .kTextDarkGray
    }
    
    var backgroundColor: Color {
        if isDisabled { return .kTextMiddleGray30 }
        return .white
    }
    
    var rightImageColor: Color {
        if isDisabled { return .kTextDarkGray }
        else if isError { return .kDeclinedStatusRed }
        return .kPurple
    }
}

// MARK: - Constants
private extension TextInput {
    struct Constants {
        static let animation: Animation = .easeInOut(duration: 0.2)
        
        static let padding = 16.0
        static let borderPadding = 1.0
        static let stackSpacing = 8.0
        static let TextInputBoxHeight = 54.0
        static let TextInputBoxCornerRadius = 6.0
        static let TextInputBoxBorderWidth = 1.0
        static let TextInputYOffset = 10.0
        static let placholderYOffset = -12.0
        static let placeholderZIndex = 100.0
    }
}

// MARK: - Preview
public struct TextInputPreview: View {
    @State var firstname = ""
    @State var phoneNumber = ""
    @State var email = ""
    @State var dateOfBirth = ""
    @State var state = ""
    @State var zip = ""
    @State var ssnFull = ""
    @State var ssn4 = ""
    @State var isValidFirstname = false
    @State var isValidPhoneNumber = false
    @State var isValidEmail = false
    @State var isDisabled = false
    @FocusState var focusedField: Field?
    
    enum Field: Hashable {
        case firstname, phoneNumber, email, dateOfBirth, state, zip, ssnFull, ssn4
    }
    
    public init() {}
    public var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Button("Enable/Disable") {
                        isDisabled.toggle()
                    }
                    .padding()
                    TextInput(
                        type: .default,
                        text: $firstname,
                        placeholder: "First name"
                    )
                    .setIsValid($isValidFirstname)
                    .setIsDisabled($isDisabled)
                    .setIsErrorTextNeeded(true)
                    .focused($focusedField, equals: .firstname)
                    .onSubmit {
                        focusedField = .phoneNumber
                    }
                    
                    TextInput(
                        text: $phoneNumber,
                        placeholder: "Phone number"
                    )
                    .setIsValid($isValidPhoneNumber)
                    .setFormatter(PhoneNumberFormatter())
                    .setValidator(PhoneNumberValidator())
                    .setIsDisabled($isDisabled)
                    .setIsErrorTextNeeded(true)
                    .focused($focusedField, equals: .phoneNumber)
                    .onSubmit {
                        focusedField = .email
                    }
                    
                    TextInput(
                        type: .email,
                        text: $email,
                        placeholder: "Email"
                    )
                    .setIsValid($isValidEmail)
                    .setIsDisabled($isDisabled)
                    .setIsErrorTextNeeded(true)
                    .setRightImage(Image.init(systemName: "chevron.right"))
                    .focused($focusedField, equals: .email)
                }
            }
        }
        .padding(.horizontal)
    }
}

#if DEBUG
#Preview {
    TextInputPreview()
}
#endif
