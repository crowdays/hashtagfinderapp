//
//  FeedViewModel.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/10/23.
//

import Foundation



class FeedViewModel: ObservableObject {
    @Published var drops = [Drop]()
    let service = DropService()
    let userService = UserService()
    init() {
        fetchDrops()
        
    }
    
    func fetchDrops() {
        service.fetchDrops { drops in
            
            self.drops = drops
            
            for i in 0 ..< drops.count {
                let uid = drops[i].uid
                
                self.userService.fetchUser(withUid: uid) { user in
                    self.drops[i].user = user 
                    
                    
                    
                }
                
         
                    
                }
            }
        }
    }

