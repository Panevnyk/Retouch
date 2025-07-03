//
//  TermsAndConditionsViewModel.swift
//  RetouchMore
//
//  Created by Vladyslav Panevnyk on 16.03.2021.
//

import Foundation
import RetouchNetworking
import RetouchUtils
import RetouchDesignSystem

public final class TermsAndConditionsViewModel: InfoViewModelProtocol, Sendable {
    public let headerTitle: String
    public let messageText: String
    public let pageURL: URL?

    public init() {
        self.headerTitle = "Terms of Use"
        self.pageURL = URL(string: RestApiConstants.baseURL + "/auth/terms-of-use")
        self.messageText =
"""
This document is an offer to make an agreement with  «RetouchYou», providing services to you (hereinafter - the "User", and collectively - the "Parties"), using this application, on the terms and conditions mentioned below.
Note: This agreement creates mutual rights and obligations for the Parties, and generates the creates  legal consequences. If the User does not accept the terms of the agreement, he confirms not to use application.

1. By using RetouchYou service, you confirm that you are over 18 years old.
2. RetouchYou service undertakes to provide services for editing User’s photos on his/her request if the User has paid for this service.
3. The User should precisely specify the way he/she wants photo to be edited by RetouchYou service.
4. If the User has not expressed  his/her request as prescribed by Section 3 hereof fully, clearly and accurately, RetouchYou service reserves the right to edit photos at its descretion.
5. User is fully responsible for the content of photographs To receive photo editing service, user gives right to move, edit and delete parts of the picture.
6. If the User sends photos with images containing no people and / or photographs, contrary to morals of the society, including (but not limited to): propaganda of hatred, humiliation of honor and dignity, the images of discrimination, violence, pornography, or those bearing sexual nature, RetouchYou has the right not to edit these photographs.
7. The User who paid the cost of services specified by this Agreement has ownership rights of the edited photographs.
8. The User guarantees that he holds the copyright to the pictures sent or is authorized to act on behalf of the author. If the User believes that the RetouchYou service breached his/her copyright, he/she may send the latter to retouch.you.app@gmail.com.
9. Retouch service stores personal data such as e-mail. If edited material is not received by the User, the Retouch service may send the backup copy of the edited material to his/her e-mail.
10. Service is provided through the application  "as it is." RetouchYou service does not guarantee that the application can run without errors, and that the server for this application does not contain harmful particles or components, including viruses.
11. RetouchYou service reserves the right not to consider the User’s wish that can not be performed in a particular situation.
It may be the wish of (without limitation): changing the background, adding other objects/subjects of replacement body parts and clothing, eye opening, adding smiles, changing positions, deleting objects / subjects overshadowing people.
12. The User understands and acknowledges his/her own responsibility for the fact that he/she uses this mobile app at own risk.
"""
    }
}
