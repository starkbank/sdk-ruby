require('starkbank')

StarkBank.user = StarkBank::Project.new(
  'sandbox',
  '5690398416568320',
  '
-----BEGIN EC PRIVATE KEY-----
MHQCAQEEIIoYWZ2OGwqX6n1EVvj1C1YvWHSGqqhZJzfsZZnk0SVgoAcGBSuBBAAK
oUQDQgAEGS1jWJXoK9RUk+qoNNFquO7X4JzRf5ZA5UDJUfPCbbKe5KwtrBKTJC1/
vRGIpAM5gNsxdfKgmoXNriiuY4LEPQ==
-----END EC PRIVATE KEY-----'
)
