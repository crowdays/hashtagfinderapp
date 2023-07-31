import Foundation
import Firebase
import FirebaseFirestoreSwift
import CoreLocation

class HashtagDetailViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var filteredUsers: [User] = []
    @Published var hashtagProfiles: [HashtagProfile] = []
    @Published var userDistances: [String: Double] = [:]
    @Published var radius: Double = 0 {
        didSet {
            filterUsers()
        }
    }
    
    private var authViewModel: AuthViewModel
    private let locationManager = CLLocationManager()
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        fetchUsers()
    }
    
    func filterUsers() {
        guard let currentUserLocation = locationManager.location else {
            return
        }
        userDistances = [:] // Clear the userDistances dictionary
        filteredUsers = users.filter { user in
            let userHashtagsSet = Set(user.hashtags)
            let selectedHashtagsSet = Set(authViewModel.selectedHashtags)
            let userLocation = CLLocation(latitude: user.latitude, longitude: user.longitude)
            let distanceInMeters = currentUserLocation.distance(from: userLocation)
            let distanceInMiles = distanceInMeters / 1609.34
            let isHashtagMatch = !userHashtagsSet.isDisjoint(with: selectedHashtagsSet)
            let isWithinRadius = distanceInMiles <= radius
            if isHashtagMatch && isWithinRadius {
                userDistances[user.id ?? ""] = distanceInMiles // Add the distance to the dictionary
            }
            return isHashtagMatch && isWithinRadius
        }
    }

    
    func fetchUsers() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error fetching users: \(err)")
            } else {
                self.users = querySnapshot!.documents.compactMap { (document) -> User? in
                    if let user = try? document.data(as: User.self) {
                        HashtagProfileService.shared.fetchHashtagProfile(userId: user.id!) { profile in
                            print("Fetched HashtagProfile for user: \(user.id ?? ""), Data: \(profile)") // Added print statement
                            self.hashtagProfiles.append(profile)
                            self.filterUsers()
                        }
                        return user
                    } else {
                        return nil
                    }
                }
                print("Fetched users: \(self.users)") // Added print statement
            }
        }
    }

    
    func getHashtagProfile(for user: User) -> HashtagProfile? {
        return self.hashtagProfiles.first(where: { $0.userId == user.id })
    }
    

    
}





