const fs = require('fs')
const unixSocket = '/home/shared_socket/nodejs.sock'
const http = require('http')
const server = http.createServer((req, res) => {
  res.statusCode = 200
  res.setHeader('Content-Type', 'text/plain')
  res.end('Hello world! Nodejs works!\n')
})
if (unixSocket && fs.existsSync(unixSocket)) fs.unlinkSync(unixSocket)
server.listen(unixSocket || process.env.PORT || 80, () => {
  if (unixSocket) fs.chmodSync(unixSocket, 755)
  console.log('Server running at ' + (unixSocket || process.env.PORT || 80))
})
