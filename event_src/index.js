exports.handler = async (event) => {
  // Record the incomming event in the CloudWatch Log
  console.log(event)

  // Return our response to API Gateway
  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(event)
  }
}