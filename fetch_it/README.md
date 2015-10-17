To run the example application:

  # terminal 1:
  cd fetch_it
  bundle
  bundle exec rackup

  # terminal 2:
  # Index: list the hello words (especifying api version through the
query string)
  curl -i 'http://localhost:8888/api/hello?api_version=1.0' -H
'Authorization: Bearer XYZ'

  # Show: list one of the hello words (especifying api version through a
header)
  curl -i 'http://localhost:8888/api/hello/1' -H 'X-Api-Version: 1.0' -H
'Authorization: Bearer XYZ'

  # NotFound: Hello word will not be found under API 2.0
  curl -i 'http://localhost:8888/api/hello/1' -H 'X-Api-Version: 2.0' -H
'Authorization: Bearer XYZ'
  #Note: The Authorization header is made required in the application to
emulate OAuth2 (but not used)

# Blog post
praxis app
