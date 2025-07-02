//
//  ServiceFactory.swift
//  RetouchMain
//
//  Created by Vladyslav Panevnyk on 09.02.2021.
//

import Foundation
import RetouchUtils
import RetouchDesignSystem
import RetouchNetworking

@MainActor
public protocol ServiceFactoryProtocol {
    func makeJSONDecoder() -> JSONDecoder
    func makeRestApiManager() -> RestApiManager
//    func makePushNotificationService() -> PushNotificationServiceProtocol
    func makeDataLoader() -> DataLoaderProtocol
    func makeOrdersLoader() -> OrdersLoaderProtocol
    func makeSilentOrdersLoader() -> SilentOrdersLoaderProtocol
    func makeRetouchGroupsLoader() -> RetouchGroupsLoaderProtocol
    func makeCurrentUserLoader() -> CurrentUserLoaderProtocol
    func makePHImageLoader() -> PHImageLoaderProtocol
    func makeCameraPresenter() -> CameraPresenterProtocol
    func makePHPhotoLibraryPresenter() -> PHPhotoLibraryPresenterProtocol
    func makeReachabilityService() -> ReachabilityServiceProtocol
    func makeDeepLinkHelper() -> DeepLinkHelperProtocol
//    func makeRemoteConfigService() -> RemoteConfigServiceProtocol
    func makeIAPService() -> IAPServiceProtocol
    func makeStoreKitService() -> StoreKitServiceProtocol
    func makeReviewByURLService() -> ReviewByURLServiceProtocol
    func makeFeedbackService() -> FeedbackServiceProtocol
    func makeSavePhotoInfoService() -> SavePhotoInfoServiceProtocol
    func makeFreeGemCreditCountService() -> FreeGemCreditCountServiceProtocol
    func makeRewardedAdsService() -> RewardedAdsServiceProtocol
    func makeEarnCreditsService() -> EarnCreditsServiceProtocol
}

@MainActor
public class ServiceFactory: NSObject, ServiceFactoryProtocol {
    var jsonDecoder: JSONDecoder!
    var restApiManager: RestApiManager!
//    var pushNotificationService: PushNotificationServiceProtocol!
    var dataLoader: DataLoaderProtocol!
    var ordersLoader: OrdersLoaderProtocol!
    var silentOrdersLoader: SilentOrdersLoaderProtocol!
    var retouchGroupsLoader: RetouchGroupsLoaderProtocol!
    var currentUserLoader: CurrentUserLoaderProtocol!
    var reachabilityService: ReachabilityServiceProtocol!
//    var remoteConfigService: RemoteConfigServiceProtocol!
    var iapService: IAPServiceProtocol!

    static var shared: ServiceFactoryProtocol = ServiceFactory()

    override init() {
        super.init()

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60.0

        let urlSession = URLSession(
            configuration: sessionConfig,
            delegate: self,
            delegateQueue: OperationQueue.main
        )
        jsonDecoder = JSONDecoder()
        restApiManager = URLSessionRestApiManager(
            urlSessionRAMDIContainer: URLSessionRAMDIContainer(
                urlSession: urlSession,
                jsonDecoder: JSONDecoder(),
                printRequestInfo: true,
                timeoutInterval: 60
            )
        )
    }

    public func makeJSONDecoder() -> JSONDecoder {
        return jsonDecoder
    }
    
    public func makeRestApiManager() -> RestApiManager {
        return restApiManager
    }

//    public func makePushNotificationService() -> PushNotificationServiceProtocol {
//        if pushNotificationService == nil {
//            pushNotificationService = PushNotificationService(jsonDecoder: makeJSONDecoder(),
//                                                              restApiManager: makeRestApiManager(),
//                                                              ordersLoader: makeOrdersLoader(),
//                                                              dataLoader: makeDataLoader())
//        }
//
//        return pushNotificationService
//    }

    public func makeDataLoader() -> DataLoaderProtocol {
        if dataLoader == nil {
            dataLoader = DataLoader(
                ordersLoader: makeOrdersLoader(),
                silentOrdersLoader: makeSilentOrdersLoader(),
                retouchGroupsLoader: makeRetouchGroupsLoader(),
                currentUserLoader: makeCurrentUserLoader()
            )
        }

        return dataLoader
    }

    public func makeOrdersLoader() -> OrdersLoaderProtocol {
        if ordersLoader == nil {
            ordersLoader = OrdersLoader(restApiManager: restApiManager)
        }

        return ordersLoader
    }
    
    public func makeSilentOrdersLoader() -> SilentOrdersLoaderProtocol {
        if silentOrdersLoader == nil {
            silentOrdersLoader = SilentOrdersLoader(ordersLoader: makeOrdersLoader(),
                                                    currentUserLoader: makeCurrentUserLoader())
        }

        return silentOrdersLoader
    }

    public func makeRetouchGroupsLoader() -> RetouchGroupsLoaderProtocol {
        if retouchGroupsLoader == nil {
            retouchGroupsLoader = RetouchGroupsLoader(restApiManager: restApiManager)
        }

        return retouchGroupsLoader
    }

    public func makeCurrentUserLoader() -> CurrentUserLoaderProtocol {
        if currentUserLoader == nil {
            currentUserLoader = CurrentUserLoader(restApiManager: restApiManager)
        }

        return currentUserLoader
    }

    public func makePHImageLoader() -> PHImageLoaderProtocol {
        return PHImageLoader()
    }

    public func makeCameraPresenter() -> CameraPresenterProtocol {
        return CameraPresenter()
    }

    public func makePHPhotoLibraryPresenter() -> PHPhotoLibraryPresenterProtocol {
        return PHPhotoLibraryPresenter()
    }

    public func makeReachabilityService() -> ReachabilityServiceProtocol {
        if reachabilityService == nil {
            reachabilityService = ReachabilityService()
        }

        return reachabilityService
    }

    public func makeDeepLinkHelper() -> DeepLinkHelperProtocol {
        return DeepLinkHelper()
    }

//    public func makeRemoteConfigService() -> RemoteConfigServiceProtocol {
//        if remoteConfigService == nil {
//            remoteConfigService = RemoteConfigService()
//        }
//
//        return remoteConfigService
//    }

    public func makeIAPService() -> IAPServiceProtocol {
        if iapService == nil {
            iapService = IAPService(restApiManager: restApiManager)
        }
        return iapService
    }
    
    public func makeStoreKitService() -> StoreKitServiceProtocol {
        return StoreKitService()
    }
    
    public func makeReviewByURLService() -> ReviewByURLServiceProtocol {
        return ReviewByURLService()
    }
    
//    public func makeLocalFeedbackService() -> LocalFeedbackServiceProtocol {
//        return LocalFeedbackService(ordersLoader: makeOrdersLoader())
//    }
    
    public func makeFeedbackService() -> FeedbackServiceProtocol {
        return FeedbackService(storeKitService: makeStoreKitService()/*,
                               localFeedbackService: makeLocalFeedbackService(),
                               remoteConfigService: makeRemoteConfigService()*/)
    }
    
    public func makeSavePhotoInfoService() -> SavePhotoInfoServiceProtocol {
        return SavePhotoInfoService()
    }
    
    public func makeFreeGemCreditCountService() -> FreeGemCreditCountServiceProtocol {
        return FreeGemCreditCountService()
    }
    
    public func makeRewardedAdsService() -> RewardedAdsServiceProtocol {
        return RewardedAdsService()
    }
    
    public func makeEarnCreditsService() -> EarnCreditsServiceProtocol {
        return EarnCreditsService(storeKitService: makeStoreKitService(),
                                  reviewByURLService: makeReviewByURLService(),
                                  rewardedAdsService: makeRewardedAdsService(),
                                  restApiManager: makeRestApiManager())
    }
}

// MARK: - URLSessionDelegate
extension ServiceFactory: URLSessionDelegate {
    nonisolated public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        if challenge.protectionSpace.host == "localhost" {
            #if DEBUG
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
            #else
            completionHandler(.performDefaultHandling, nil)
            #endif
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
