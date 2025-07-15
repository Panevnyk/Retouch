import Testing
@testable import RetouchDomain

@Suite(.tags(.model))
struct OrderTests {
    
    @Test func initWithAllFields() {
        let order = Order(
            id: "123",
            userId: "user-001",
            adminId: "admin-001",
            client: "Client Name",
            designer: "Designer Name",
            beforeImage: "before.jpg",
            afterImage: "after.jpg",
            selectedRetouchGroups: [SelectedRetouchGroup(id: "group-1")],
            price: 120,
            creationDate: 1680000000000,
            finishDate: 1680000360000,
            calculatedWaitingTime: 360000,
            rating: 5,
            isPayed: true,
            isPayedForUrgent: true,
            isRedo: false,
            redoDescription: "none",
            isNewOrder: true,
            status: .completed,
            statusDescription: "Finished successfully"
        )

        #expect(order.id == "123")
        #expect(order.userId == "user-001")
        #expect(order.adminId == "admin-001")
        #expect(order.client == "Client Name")
        #expect(order.designer == "Designer Name")
        #expect(order.beforeImage == "before.jpg")
        #expect(order.afterImage == "after.jpg")
        #expect(order.selectedRetouchGroups.map(\.self.id) == [SelectedRetouchGroup(id: "group-1")].map(\.self.id))
        #expect(order.price == 120)
        #expect(order.creationDate == 1680000000000)
        #expect(order.finishDate == 1680000360000)
        #expect(order.calculatedWaitingTime == 360000)
        #expect(order.rating == 5)
        #expect(order.isPayed == true)
        #expect(order.isPayedForUrgent == true)
        #expect(order.isRedo == false)
        #expect(order.redoDescription == "none")
        #expect(order.isNewOrder)
        #expect(order.status == .completed)
        #expect(order.statusDescription == "Finished successfully")
        #expect(order.isCompleted == true)
    }
    
    @Test func initWithNilAndEmptyValues() {
        let order = Order(
            id: "124",
            userId: "user-002",
            adminId: nil,
            client: "Client B",
            designer: nil,
            beforeImage: nil,
            afterImage: nil,
            selectedRetouchGroups: [],
            price: 0,
            creationDate: 0,
            finishDate: 0,
            calculatedWaitingTime: 0,
            rating: nil,
            isPayed: false,
            isPayedForUrgent: false,
            isRedo: true,
            redoDescription: nil,
            isNewOrder: false,
            status: .waiting,
            statusDescription: nil
        )
        
        #expect(order.id == "124")
        #expect(order.userId == "user-002")
        #expect(order.adminId == nil)
        #expect(order.client == "Client B")
        #expect(order.designer == nil)
        #expect(order.beforeImage == nil)
        #expect(order.afterImage == nil)
        #expect(order.selectedRetouchGroups.count == 0)
        #expect(order.price == 0)
        #expect(order.creationDate == 0)
        #expect(order.finishDate == 0)
        #expect(order.calculatedWaitingTime == 0)
        #expect(order.rating == nil)
        #expect(order.isPayed == false)
        #expect(order.isPayedForUrgent == false)
        #expect(order.isRedo == true)
        #expect(order.redoDescription == nil)
        #expect(order.isNewOrder == false)
        #expect(order.status == .waiting)
        #expect(order.statusDescription == nil)
        #expect(order.isCompleted == false)
    }
    
    @Test func isCompletedComputedProperty() {
        let completedOrder = Order(
            id: "id",
            userId: "user",
            adminId: nil,
            client: "client",
            designer: nil,
            beforeImage: nil,
            afterImage: nil,
            selectedRetouchGroups: [],
            price: 0,
            creationDate: 0,
            finishDate: 0,
            calculatedWaitingTime: 0,
            rating: nil,
            isPayed: false,
            isPayedForUrgent: false,
            isRedo: false,
            redoDescription: nil,
            isNewOrder: false,
            status: .completed,
            statusDescription: nil
        )
        #expect(completedOrder.isCompleted == true)
        
        let inReviewOrder = Order(
            id: "id",
            userId: "user",
            adminId: nil,
            client: "client",
            designer: nil,
            beforeImage: nil,
            afterImage: nil,
            selectedRetouchGroups: [],
            price: 0,
            creationDate: 0,
            finishDate: 0,
            calculatedWaitingTime: 0,
            rating: nil,
            isPayed: false,
            isPayedForUrgent: false,
            isRedo: false,
            redoDescription: nil,
            isNewOrder: false,
            status: .inReview,
            statusDescription: nil
        )
        #expect(inReviewOrder.isCompleted == false)
    }
}

extension SelectedRetouchGroup {
    convenience init(id: String) {
        self.init(
            id: id,
            retouchGroupId: "1324",
            retouchGroupTitle: "Test title",
            selectedRetouchTags: [],
            descriptionForDesigner: "Test description"
        )
    }
}
