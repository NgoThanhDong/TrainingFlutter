class QueryMutation {
  
  String getCategories(){
    return '''
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
  }

  String getTags(){
    return '''
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
  }

  String getPosts(){
    return r'''
      query getPost($nRepositories: Int!, $cursor: String) {
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
              createdDate
              category {
                name
              }
              author {
                username
              }
              tags {
                edges {
                  node {
                    name
                  }
                }
              }
            }
          }
          pageInfo {
            endCursor
            hasNextPage
          }
        }
      }
    ''';
  }

}
