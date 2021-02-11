exports.handler = async (event) => {
  // Record the incomming event in the CloudWatch Log
  console.log(event)

  let name = (event.queryStringParameters && event.queryStringParameters.name) || 'World'
  // Return our response to API Gateway

  if(event.headers.accept.includes('application/json')) {
    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        message: `Hello ${name}`,
        method: event.httpMethod,
        client_ip: event.headers['X-Forwarded-For']
      })
    }
  }
  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'text/html'
    },
    body: `<html><body><h1>Hello ${name}</h1><p>HTTP Method: ${event.httpMethod}</p><p>Client IP: ${event.headers['X-Forwarded-For']}</p></body></html>`
  }
}