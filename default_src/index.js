exports.handler = async (event) => {
  // Record the incomming event in the CloudWatch Log
  console.log(event)

  // Return our response to API Gateway
  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'text/html'
    },
    body: '<html><body><h1>Hello World</h1></body></html>'
  }
}