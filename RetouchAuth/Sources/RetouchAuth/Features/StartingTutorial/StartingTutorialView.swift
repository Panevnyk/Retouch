import SwiftUI
import RetouchDomain
import RetouchDesignSystem

public struct StartingTutorialView: View {
    @ObservedObject
    private var viewModel: StartingTutorialViewModel
    
    public init(viewModel: StartingTutorialViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        bodyView
            .background(Color.kBlue)
            .onAppear(perform: viewModel.onAppear)
    }

    var bodyView: some View {
        ZStack(alignment: .top) {
            tabView
            
            header
            
            footer
        }
    }
    
    var header: some View {
        ZStack(alignment: .center) {
            Text(viewModel.headerText)
                .foregroundColor(.white)
                .font(.kBigTitleText)
            
            HStack {
                Spacer()
                
                ClearButton(
                    text: viewModel.skipText,
                    action: viewModel.skipAction
                )
                .padding(.trailing, 16)
            }
        }
        .frame(height: 64)
    }
    
    var footer: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                MainSmallButton(
                    text: viewModel.nextText,
                    action: viewModel.nextAction
                )
                .padding(.trailing, 16)
            }
        }
    }
    
    var tabView: some View {
        TabView(selection: $viewModel.selectedItem) {
            ForEach(0 ..< viewModel.tutorialImagesArray.count) { index in
                ZStack {
                    Image(viewModel.tutorialImagesArray[index].bgImageView, bundle: .designSystem)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Image(viewModel.tutorialImagesArray[index].imageView, bundle: .designSystem)
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page)
        .ignoresSafeArea()
    }
}

// MARK: - UserDefaults isShowen
extension StartingTutorialView {
    private static let userDefaultsIsShowenKey = "StartingTutorialUserDefaultsIsShowenKey"
    public static var isShowen: Bool {
        get {
            UserDefaults.standard.bool(
                forKey: StartingTutorialView.userDefaultsIsShowenKey
            )
        }
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: StartingTutorialView.userDefaultsIsShowenKey
            )
        }
    }
}
