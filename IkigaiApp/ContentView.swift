//
//  ContentView.swift
//  Ikigai
//
//  Created by Vince Davis on 1/29/25.
//

import SwiftUI
import SwiftData
import IkigaiCore


struct ContentView: View {
    var body: some View {
        Text("Hello")
        .task {
            await runExampleJsonREST()
        }
    }
    
    // MARK: - Usage Example
    func runExampleJsonREST() async {
        let service = JSONPlaceholderService()
        
        do {
            // Fetch all posts
            let posts = try await service.fetchAllPosts()
            print("Fetched \(posts.count) posts")
            
            // Fetch a specific post
            let post = try await service.fetchPost(id: 1)
            print("Post title: \(post.title)")
            
            // Create a new post
            let newPost = try await service.createPost(
                userId: 1,
                title: "New Post",
                body: "This is a test post"
            )
            print("Created post ID: \(newPost.id ?? 0)")
            
            // Update a post
            let updatedPost = try await service.updatePost(
                id: 1,
                userId: 1,
                title: "Updated Post",
                body: "This is an updated test post"
            )
            print("Updated post title: \(updatedPost.title)")
            
            // Delete a post
            try await service.deletePost(id: 1)
            print("Post deleted successfully")
        } catch {
            print("Error: \(error)")
        }
    }
}

#Preview {
    ContentView()
}

//import IkigaiMacros
//@NavigationTitle("Hello, World!")
//struct MacroView: View {}
