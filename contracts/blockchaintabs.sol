//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


contract blockchaintabs {
    // Struct to represent a user account
    struct User {
        bytes32 hashedPassword;
        string email;
        string name;
        address myaddress;
    }

    // Mapping from email address to user account
    mapping(string => User) public users;

    // Register a new user account
    function register(string memory _email, string memory _password, string memory _name) public {
        // Hash the password
        bytes32 hashedPassword = sha256(abi.encodePacked(_password));
       require(isUserRegistered(msg.sender)==false, "User already registered");
        // Create a new user account
        User memory user = User({
       hashedPassword: hashedPassword,
        email: _email,
        name: _name,
       myaddress: msg.sender
        });

        // Store the user account in the mapping
        users[_email] = user;
    }

    // Login to an existing user account
    function login(string memory _email, string memory _password) public view returns (bool) {
        // Retrieve the user account for the given email address
        User memory user = users[_email];
  require(isUserRegistered(msg.sender)==true, "User not registered");

        // Check that the provided password matches the hashed password in the user account
        return sha256(abi.encodePacked(_password)) == user.hashedPassword;
    }
// 




  address[] public registeredUsers;

function isUserRegistered(address user) public view returns (bool) {
    for(uint i=0;i< registeredUsers.length;i++){
        if(registeredUsers[i]==user)
            return true;
    }
    return false;
}

    // Struct for a post
    struct Post {
        uint id;
        address owner;
        string content;
        bytes imageHash; // Add a field for the image hash
        uint timestamp;
    }

    // Struct for a comment
    struct Comment {
    uint id;
    uint postId;
    address user;
    string content;
    uint timestamp;
}

   
      mapping(uint256 => Post) public posts;
   
    // Mapping from comment id to comment struct
    mapping(uint => Comment) public comments;
    mapping(uint => uint[]) postComments;



    // Counter for post id
    uint public postCounter;
    // Counter for comment id
    uint public commentCounter;

 function createPost(string memory content, bytes memory image) public {
    // Increment the post counter and set the post id
    uint id = postCounter++;
    // Create a new post struct and add it to the mapping
    posts[id] = Post(id, msg.sender, content, image, block.timestamp);
    postComments[id] = new uint[](0);
}
function createComment(uint postId, string memory content) public {
    // Increment the comment counter and set the comment id
    uint id = commentCounter++;
    // Create a new comment struct and add it to the mapping
      comments[id] = Comment(id, postId, msg.sender, content, block.timestamp);
    postComments[postId].push(id);
}


 

  // Array to store the IDs of all posts
  uint[] public postIds;


    

  


  function searchPosts(string memory keyword) public view returns (uint[] memory matchingPostIds) {
  // Create an empty array to store the IDs of matching posts
  matchingPostIds = new uint[](0);

  // Loop through all the posts and check if the keyword appears in the content
  for (uint i = 0; i < postIds.length; i++) {
    uint id = postIds[i];
    if (contains(bytes(posts[id].content), bytes(keyword))) {
      // If the keyword appears in the content, add the ID to the matching post IDs array
      uint length = matchingPostIds.length;
      delete matchingPostIds;
      matchingPostIds = new uint[](length + 1);
      matchingPostIds[length] = id;
    }
  }

  // Return the array of matching post IDs
  return matchingPostIds;
}


  function contains(bytes memory haystack, bytes memory needle) public pure returns (bool) {
  for (uint i = 0; i < haystack.length; i++) {
    if (haystack[i] == needle[0]) {
      bool ismatch = true;
      for (uint j = 1; j < needle.length; j++) {
        if (haystack[i + j] != needle[j]) {
          ismatch = false;
          break;
        }
      }
      if (ismatch) {
        return true;
      }
    }
  }
  return false;
}

function getPostsByLoggedInUser() public view returns (Post[] memory, Comment[] memory) {
    // Create empty arrays to store the posts and comments
    Post[] memory postsByUser = new Post[](postCounter);
    Comment[] memory commentsByUser = new Comment[](commentCounter);

    // Iterate over all posts and add only the ones that belong to the logged in user
    uint postIndex = 0;
    for (uint i = 0; i < postCounter; i++) {
        if (posts[i].owner == msg.sender) {
            // Add the post to the array using the postIndex variable
            postsByUser[postIndex] = posts[i];
            postIndex++;

            // Iterate over all comments and add only the ones that belong to the post
            uint commentIndex = 0;
            for (uint j = 0; j < commentCounter; j++) {
                if (comments[j].postId == posts[i].id) {
                    // Add the comment to the array using the commentIndex variable
                    commentsByUser[commentIndex] = comments[j];
                    commentIndex++;
                }
            }
        }
    }

    // Return the arrays of posts and comments by the logged in user
    return (postsByUser, commentsByUser);

}



uint public postCount;

mapping(uint => bool) public deletedPosts;

function getAllPostsAndComments() public view returns (Post[] memory) {
    Post[] memory result = new Post[](postCount);
    uint i = 0;
    for (uint j = 0; j < postCount; j++) {
        if(!deletedPosts[j]){
            result[i] = posts[j];
            i++;
        }
    }
    return result;
}



}

  






   

   









