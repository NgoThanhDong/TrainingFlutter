class QueryMutation {
  
  String getCategories = '''
    {
      categories {
        edges {
          node {
            id
            name
          }
        }
      }
    }
  ''';
  
  String getTags = '''
    {
      tags {
        edges {
          node {
            id
            name
          }
        }
      }
    }
  ''';
  
  String getPosts = r'''
    query getPosts ($nRepositories: Int!, $cursor: String) {
      posts (first: $nRepositories, after: $cursor) {
        totalCount
        edges {
          node {
            id
            title
            image
            description
            content
            postType
            category {
              id
              name
            }
            author {
              username
            }
            tags {
              edges {
                node {
                  id
                  name
                }
              }
            }
            url
            createdDate
          }
        }
        pageInfo {
          endCursor
          hasNextPage
        }
      }
    }
  ''';
  
  String login = r'''
    mutation login ($username: String!, $password: String!) {
      tokenAuth (username: $username, password: $password) {
       token
      }
    }
  ''';
  
  String getUser = r'''
    query getAuthor ($username: String!) {
      users (username_Iexact: $username) {
        edges {
          node {
            id
            username
            email
            avatar
          }
        }
      }
    }
  ''';
  
  String uploadImage = r'''
    mutation uploadImage ($file: Upload!) {
      upload (file: $file, uploadType: "post") {
        uploadedFileName
      }
    }
  ''';
  
  String createPost = r'''
    mutation createPost ($title: String!, $image: String, $description: String!, $content: String!,
        $author: ID, $postType: String!, $category: ID, $tags: [ID]!, $url: String!) {
      post (input: {
        title: $title
        image: $image
        description: $description
        content: $content
        author: $author
        postType: $postType
        category: $category
        tags: $tags
        url: $url
        published: true
      }) {
        errors {
          field
          messages
        }
        post {
          id
          title
          image
          description
          content
          author {
            id
            username
          }
          postType
          category {
            id
            name
          }
          tags {
            edges {
              node {
                id
                name
              }
            }
          }
          url
          createdDate
          updatedDate
          deletedDate
        }
      }
    }
  ''';
  
  String editPost = r'''
    mutation editPost ($id: ID, $title: String!, $image: String, $description: String!,
        $content: String!, $postType: String!, $category: ID, $tags: [ID]!, $url: String!) {
      post (input: {
        id: $id
        title: $title
        image: $image
        description: $description
        content: $content
        postType: $postType
        category: $category
        tags: $tags
        url: $url
        published: true
      }) {
        errors {
          field
          messages
        }
        post {
          id
          title
          image
          description
          content
          author {
            id
            username
          }
          postType
          category {
            id
            name
          }
          tags {
            edges {
              node {
                id
                name
              }
            }
          }
          url
          createdDate
          updatedDate
          deletedDate
        }
      }
    }
  ''';
  
  String deletePost = r'''
    mutation deletePost ($id: ID, $title: String!, $image: String, $description: String!, $content: String!,
         $postType: String!, $category: ID, $tags: [ID]!, $url: String!, $deletedDate: DateTime) {
      post (input: {
        id: $id
        title: $title
        image: $image
        description: $description
        content: $content
        postType: $postType
        category: $category
        tags: $tags
        url: $url
        deletedDate: $deletedDate
        published: true
      }) {
        errors {
          field
          messages
        }
        post {
          id
          title
          image
          description
          content
          author {
            id
            username
          }
          postType
          category {
            id
            name
          }
          tags {
            edges {
              node {
                id
                name
              }
            }
          }
          url
          createdDate
          updatedDate
          deletedDate
        }
      }
    }
  ''';
  
}
