//
//  PrivacyPolicyViewModel.swift
//  RetouchMore
//
//  Created by Vladyslav Panevnyk on 16.03.2021.
//

import Foundation
import RetouchUtils
import RetouchNetworking
import RetouchDesignSystem

public final class PrivacyPolicyViewModel: InfoViewModelProtocol {
    public let headerTitle: String
    public let messageText: String
    public let pageURL: URL?

    public init() {
        self.headerTitle = "Privacy Policy"
        self.pageURL = URL(string: RestApiConstants.baseURL + "/auth/privacy-policy")
        self.messageText =
"""
RetouchYou does not share or sell personal information of Customers.


Information we collect

RetouchYou collects all information about Customer request: signature to identify Client in Service, time when image was sent and received, reason of rejection in case photo was rejected, Customer email address, photo that Customer sends to us, price Customer payed for retouch, list of services Customer ordered for retouch, rating of retouch provided by Customer. RetouchYou does not know payment information of Customer, Service use in-app purchase mechanisms of application platform so RetouchYou does not have access to personal and financial data from ID of Customer.


How we use information

RetouchYou uses information to execute order and provide retouching service. We use customer email address to deliver edited photo. We delete customer photos after delivering it to the customer. As well RetouchYou checks statistics to know about repeat sales. RetouchYou uses ratings as feedback from Customers users on Service work.


Security

We take reasonable precaution to protect Personal Information from misuse, loss and unauthorized access. Although we cannot guarantee that Personal Information will not be subject to unauthorized access, we have physical, electronic, and procedural safeguards in place to protect Personal Information. Personal Information is stored on our servers and protected by secured networks to which access is limited to a few authorized employees and personnel. However, no method of transmission over the Internet, or method of electronic storage, is 100% secure.


How contact us

If you have any questions about this Privacy Policy or the Service, you can connect with RetouchYou team via email retouch.you.app@gmail.com
"""
    }
}
