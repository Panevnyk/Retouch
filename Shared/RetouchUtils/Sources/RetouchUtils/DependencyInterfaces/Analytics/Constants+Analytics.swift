//
//  Constant+Analytics.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 29.06.2021.
//

public extension Constants {
    struct Analytics {
        public enum EventScreen: String {
            // Auth
            case login = "scr_login"
            case registration = "scr_registration"
            case forgotPassword = "scr_forgot_password"
            case resetPassword = "scr_reset_password"
            case fastSignIn = "scr_fast_sign_in"
            case startingTutorial = "scr_starting_tutorial"

            // Home
            case homeHistory = "scr_home_history"
            case homeGallery = "scr_home_gallery"
            case photo = "scr_photo"
            case albumGallery = "scr_album_gallery"
            case retouchingPhoto = "scr_retouching_photo"
            case balance = "scr_balance"
            case orderDetail = "scr_order_detail"
            case detailTagAlert = "scr_detail_tag_alert"
            case internetConnectionErrorAlert = "scr_internet_connection_error_alert"
            case noAccessToGalleryAlert = "scr_no_access_to_gallery_alert"
            case forceUpdateAppVersion = "scr_force_update_app_version"
            case ratingAlert = "scr_rating_alert"
            case downloadSuccessfullyAlert = "scr_download_successfully_alert"
            case firstRetouchingForFreeAlert = "scr_first_retouching_for_free_alert"

            // Examples
            case examples = "scr_examples"
            case examplesDetail = "scr_examples_detail"

            // More
            case more = "scr_more"
            case privacyPolicy = "scr_privacy_policy"
            case termsOfUse = "scr_terms_of_use"
        }
        
        public enum EventAction: String {
            // Auth
            
            // -- Privacy Policy & Terms Of Use
            case privacyPolicyAuth = "act_privacy_policy_auth"
            case termsOfUseAuth = "act_terms_of_use_auth"

            // -- FastSignIn
            case fastSignInWithApple = "act_fast_sign_in_with_apple"
            case fastSignInOtherOptions = "act_fast_sign_other_options"

            // -- StartingTutorial
            case skipStartingTutorial = "act_skip_starting_tutorial"
            case nextStartingTutorial = "act_next_starting_tutorial"
            case signInStartingTutorial = "act_sign_in_starting_tutorial"

            // Home
            // -- Balance one time
            case gems30 = "act_gems_30"
            case gems50 = "act_gems_50"
            case gems110 = "act_gems_110"
            case gems180 = "act_gems_180"
            case gems240 = "act_gems_240"
            case gems300 = "act_gems_300"
            case gems500 = "act_gems_500"
            case gems1000 = "act_gems_1000"

            // -- Balance earn
            case earnGemsViewAVideoAd = "act_earn_gems_view_a_video_ad"
            case earnGemsLeaveARatingOnAppStore = "act_earn_gems_leave_a_rating_on_app_store"
            case earnGemsLeaveAReviewByURLOnAppStore = "act_earn_gems_leave_a_review_by_url_on_app_store"
            case earnGemsFollowUsOnInstagram = "act_earn_gems_follow_us_on_instagram"
            case earnGemsFollowUsOnFacebook = "act_earn_gems_follow_us_on_facebook"
            
            // -- Home
            case openSettings = "act_open_settings"

            // -- HomeGallery
            case refreshGallery = "act_refresh_gallery"
            case cameraFromGallery = "act_camera_from_Gallery"

            // -- HomeHistory
            case refreshHistory = "act_refresh_history"
            case cameraFromHistory = "act_camera_from_History"
            case galleryFromHistory = "act_gallery_from_History"

            // -- Photo
            case detailTagAlert = "act_detail_tag_alert"
            case showOrderAlert = "act_show_order_alert"
            case showFastOrderAlert = "act_show_fast_order_alert"
            case showFreeOrderAlert = "act_show_free_order_alert"
            case showOutOfFreeOrderAlert = "act_show_out_of_free_order_alert"
            
            case didAddDetailTag = "act_did_add_detail_tag"
            case makeOrder = "act_make_order"
            case makeFastOrder = "act_make_fast_order"
            case makeOutOfFreeFastOrder = "act_out_of_free_fast_order"
            case makeFreeOrder = "act_make_free_order"
            case showBalanceFromOrder = "act_show_balance_from_order"
            case didUpdateOpenTagIndex = "act_did_update_open_tag_index"

            // -- OrderDetail
            case download = "act_download"
            case share = "act_share"
            case redo = "act_redo"
            case didTapRating = "act_did_tap_rating"
            case sendRating = "act_send_rating"
            case cancelRating = "act_cancel_rating"
            case sendIsNotNewOrder = "act_send_is_not_new_order"
            case showOrderFullScreen = "act_show_order_full_screen"
            case showOrderNotFullScreen = "act_show_order_not_full_screen"

            // -- ForceUpdateAppVersion
            case forceUpdateAppVersion = "act_force_update_app_version"

            // Examples
            // -- Detail
            case showExamplesFullScreen = "act_show_examples_full_screen"
            case showExamplesNotFullScreen = "act_show_examples_not_full_screen"

            // More
            // -- List
            case shareAppStoreLink = "act_share_app_store_link"
            case writeToDevelopers = "act_write_to_developers"
            case termsOfUseFromMore = "act_terms_of_use_from_more"
            case privacyPolicyFromMore = "act_privacy_policy_from_more"
            case openPushNotificationSettings = "act_open_push_notification_settings"
            case removeAccount = "act_remove_account"
            case signOut = "act_sign_out"
        }
    }
}
