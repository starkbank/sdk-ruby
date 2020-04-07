# Stark Bank Ruby SDK

Welcome to the Stark Bank Ruby SDK! This tool is made for Ruby 
developers who want to easily integrate with our API.
This SDK version is compatible with the Stark Bank API v2.

If you have no idea what Stark Bank is, check out our [website](https://www.starkbank.com/) 
and discover a world where receiving or making payments 
is as easy as sending a text message to your client!

## Supported Ruby Versions

This library supports the following Ruby versions:

* Ruby 2.3+

## Stark Bank API documentation

If you want to take a look at our API, follow [this link](https://starkbank.com/docs/api/v2).

## Installation

To install the package with gem, run:

```sh
gem install starkbank
```

Or just add this to your Gemfile:

```sh
gem('starkbank', '~> 2.0.0')
```

## Creating a Project

To connect to the Stark Bank API, you need user credentials. We currently have 2
kinds of users: Members and Projects. Given the purpose of this SDK, it only
supports Projects, which is a type of user made specially for direct API
integrations. To start using the SDK, create your first Sandbox Project in our 
[website](https://sandbox.web.starkbank.com) in the Project session.

Once you've created your project, load it in the SDK:

```ruby
require('starkbank')

project = StarkBank::StarkBank.Project.new(
    environment: 'sandbox',
    id: '129817512982',
    private_key: '
-----BEGIN EC PRIVATE KEY-----
MHQCAQEEIOJ3xkQ9NRdMPLLSrX3OlaoexG8JZgQyTMdX1eISCXaCoBcGBSuBBAAK
oUQDQgAEUneBQJsBhZl8/nPQd4YUe/UqEAtyJRH01YyWrg+nsNcSRlc1GzC3DB+X
CPZXBUbsMQAbLoWXIN1pqIX2b/NE9Q==
-----END EC PRIVATE KEY-----'
)
```

Once you are done testing and want to move to Production, create a Project.new
in your Production account ([click here](https://web.starkbank.com)). Also,
when you are loading your Project, change the environment from `"sandbox"` to
`"production"` in the constructor shown above. 

NOTE: Never hard-code your private key. Get it from an environment variable, for example. 

## Setting up the user

You can inform the project to the SDK in two different ways.

The first way is passing the user argument in all methods, such as:

```ruby
require('starkbank')

balance = StarkBank::StarkBank.Balance.get(user: project)
```

Or, alternatively, if you want to use the same project on all requests,
we recommend you set it as the default user by doing:

```ruby
require('starkbank')

StarkBank.user = project

balance = StarkBank::StarkBank.Balance.get()
```

Just select the way of passing the project user that is more convenient to you.
On all following examples we will assume a default user has been set.

## Testing in Sandbox

Your initial balance is zero. For many operations in Stark Bank, you'll need funds
in your account, which can be added to your balance by creating a Boleto. 

In the Sandbox environment, 90% of the created Boletos will be automatically paid,
so there's nothing else you need to do to add funds to your account. Just create
a few and wait around a bit.

In Production, you (or one of your clients) will need to actually pay this Boleto
for the value to be credited to your account.


## Usage

Here are a few examples on how to use the SDK. If you have any doubts, check out
the function or class docstring to get more info or go straight to our [API docs].

### Get balance

To know how much money you have in your workspace, run:

```ruby
require('starkbank')

balance = StarkBank::Balance.get()

puts balance
```

### Create boletos

You can create boletos to charge customers or to receive money from accounts
you have in other banks.

```ruby
require('starkbank')

boletos = StarkBank::Boleto.create([
  Boleto.new(
    amount: 23571,  # R 235,71 
    name: 'Buzz Aldrin',
    tax_id: '012.345.678-90', 
    street_line_1: 'Av. Paulista, 200', 
    street_line_2: '10 andar',
    district: 'Bela Vista', 
    city: 'São Paulo',
    state_code: 'SP',
    zip_code: '01310-000',
    due: '2020-3-20',
    fine: 5,  # 5%
    interest: 2.5  # 2.5% per month
  )
])

boletos.each do |boleto|
  puts boleto
end
```

### Get boleto

After its creation, information on a boleto may be retrieved by passing its id. 
Its status indicates whether it's been paid.

```ruby
require('starkbank')

boleto = StarkBank::Boleto.get(id: '5155165527080960')

puts boleto
```

### Get boleto PDF

After its creation, a boleto PDF may be retrieved by passing its id. 

```ruby
require('starkbank')

pdf = StarkBank::Boleto.pdf(id: '5155165527080960')

File.open('boleto.pdf', 'w') { |file| file.write(pdf) }
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

### Delete boleto

You can also cancel a boleto by its id.
Note that this is not possible if it has been processed already.

```ruby
require('starkbank')

boleto = StarkBank::Boleto.delete(id: '5155165527080960')

puts boleto
```

### Query boletos

You can get a list of created boletos given some filters.

```ruby
require('starkbank')
require('date')

boletos = StarkBank::Boleto.query(
  after: '2020-1-1',
  before: Date.today + 1
)

boletos.each do |boleto|
  puts boleto
end
```

### Query boleto logs

Logs are pretty important to understand the life cycle of a boleto.

```ruby
require('starkbank')

logs = StarkBank::BoletoLog.query(limit: 150)

logs.each do |log|
  puts log
end
```

### Get a boleto log

You can get a single log by its id.

```ruby
require('starkbank')

log = StarkBank::BoletoLog.get(id: '5155165527080960')

puts log
```

### Create transfers

You can also create transfers in the SDK (TED/DOC).

```ruby
require('starkbank')

transfers = StarkBank::Transfer.create([
  Transfer.new(
    amount: 100,
    bank_code: '200',
    branch_code: '0001',
    account_number: '10000-0',
    tax_id: '012.345.678-90',
    name: 'Tony Stark',
    tags: %w[iron suit]
  ),
  Transfer.new(
    amount: 200,
    bank_code: '341',
    branch_code: '1234',
    account_number: '123456-7',
    tax_id: '012.345.678-90',
    name: 'Jon Snow',
    tags: []
  )
])

transfers.each do |transfer|
  puts transfer
end
```

### Query transfers

You can query multiple transfers according to filters.

```ruby
require('starkbank')

transfers = StarkBank::Transfer.query(
  after: '2020-1-1',
  before: '2020-4-1'
)

transfers.each do |transfer|
  puts transfer.name
end
```

### Get transfer

To get a single transfer by its id, run:

```ruby
require('starkbank')

transfer = StarkBank::Transfer.get(id: '5155165527080960')

puts transfer
```

### Get transfer PDF

A transfer PDF may also be retrieved by passing its id.
This operation is only valid if the transfer status is "processing" or "success". 

```ruby
require('starkbank')

pdf = StarkBank::Transfer.pdf(id: '5155165527080960')

File.open('transfer.pdf', 'w') { |file| file.write(pdf) }
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

### Query transfer logs

You can query transfer logs to better understand transfer life cycles.

```ruby
require('starkbank')

logs = StarkBank::TransferLog.query(limit: 50)

logs.each do |log|
  puts log
end
```

### Get a transfer log

You can also get a specific log by its id.

```ruby
require('starkbank')

log = StarkBank::TransferLog.get(id: '5155165527080960')

puts log
```

### Pay a boleto

Paying a boleto is also simple.

```ruby
require('starkbank')

payments = StarkBank::BoletoPayment.create([
  BoletoPayment.new(
    line: '34191.09008 61207.727308 71444.640008 5 81310001234321',
    tax_id: '012.345.678-90',
    scheduled: '2020-03-13',
    description: 'take my money',
    tags: %w[take my money],
  ),
  BoletoPayment.new(
    bar_code: '34197819200000000011090063609567307144464000',
    tax_id: '012.345.678-90',
    scheduled: '2020-03-14',
    description: 'take my money one more time',
    tags: %w[again],
  )
])

payments.each do |payment|
  puts payments
end
```

### Get boleto payment

To get a single boleto payment by its id, run:

```ruby
require('starkbank')

payment = StarkBank::BoletoPayment.get(id: '19278361897236187236')

puts payment
```

### Get boleto payment PDF

After its creation, a boleto payment PDF may be retrieved by passing its id. 

```ruby
require('starkbank')

pdf = StarkBank::BoletoPayment.pdf(id: '5155165527080960')

File.open('boleto_payment.pdf', 'w') { |file| file.write(pdf) }
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

### Delete boleto payment

You can also cancel a boleto payment by its id.
Note that this is not possible if it has been processed already.

```ruby
require('starkbank')

payment = StarkBank::BoletoPayment.delete(id: '5155165527080960')

puts payment
```

### Query boleto payments

You can search for boleto payments using filters. 

```ruby
require('starkbank')

payments = StarkBank::BoletoPayment.query([
  tags: %w[company_1 company_2]
])

payments.each do |payment|
  puts payments
end
```

### Query boleto payment logs

Searches are also possible with boleto payment logs:

```ruby
require('starkbank')

logs = StarkBank::BoletoPaymentLog.query(
  payment_ids: %w[5155165527080960 76551659167801921],
)

logs.each do |log|
  puts log
end
```


### Get boleto payment log

You can also get a boleto payment log by specifying its id.

```ruby
require('starkbank')

log = StarkBank::BoletoPaymentLog.get(id: '5155165527080960')

puts log
```

### Create utility payment

Its also simple to pay utility bills (such electricity and water bills) in the SDK.

```ruby
require('starkbank')

payments = StarkBank::UtilityPayment.create([
  UtilityPayment.new(
    line: '34197819200000000011090063609567307144464000',
    scheduled: '2020-03-13',
    description: 'take my money',
    tags: %w[take my money],
  ),
  UtilityPayment.new(
    bar_code: '34191.09008 61207.727308 71444.640008 5 81310001234321',
    scheduled: '2020-03-14',
    description: 'take my money one more time',
    tags: %w[again],
  )
])

payments.each do |payment|
  puts payment
end
```

### Query utility payments

To search for utility payments using filters, run:

```ruby
require('starkbank')

payments = StarkBank::UtilityPayment.query(
  tags: %w[electricity gas]
)

payments.each do |payment|
  puts payment
end
```

### Get utility payment

You can get a specific bill by its id:

```ruby
require('starkbank')

payment = StarkBank::UtilityPayment.get(id: '5155165527080960')

puts payment
```

### Get utility payment PDF

After its creation, a utility payment PDF may also be retrieved by passing its id. 

```ruby
require('starkbank')

pdf = StarkBank::UtilityPayment.pdf(id: '5155165527080960')

File.open('electricity_payment.pdf', 'w') { |file| file.write(pdf) }
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

### Delete utility payment

You can also cancel a utility payment by its id.
Note that this is not possible if it has been processed already.

```ruby
require('starkbank')

payment = StarkBank::UtilityPayment.delete(id: '5155165527080960')

puts payment
```

### Query utility bill payment logs

You can search for payments by specifying filters. Use this to understand the
bills life cycles.

```ruby
require('starkbank')

logs = StarkBank::UtilityPaymentLog.query(
  payment_ds: %w[102893710982379182 92837912873981273],
)

logs.each do |log|
  puts log
end
```

### Get utility bill payment log

If you want to get a specific payment log by its id, just run:

```ruby
require('starkbank')

log = StarkBank::UtilityPaymentLog.get(id: '1902837198237992')

puts log
```

### Create transactions

To send money between Stark Bank accounts, you can create transactions:

```ruby
require('starkbank')

transactions = StarkBank::Transaction.create([
  Transaction.new(
    amount: 100,  # (R$ 1.00)
    receiver_id: '1029378109327810',
    description: 'Transaction to dear provider',
    external_id: '12345',  # so we can block anything you send twice by mistake
    tags: %w[provider]
  ),
  Transaction.new(
    amount: 234,  # (R$ 2.34)
    receiver_id: '2093029347820947',
    description: 'Transaction to the other provider',
    external_id: '12346',  # so we can block anything you send twice by mistake
    tags: %w[provider]
  )
])

transactions.each do |transaction|
  puts transaction
end
```

### Query transactions

To understand your balance changes (bank statement), you can query
transactions. Note that our system creates transactions for you when
you receive boleto payments, pay a bill or make transfers, for example.

```ruby
require('starkbank')

transactions = StarkBank::Transaction.query(
  after: '2020-01-01',
  before: '2020-03-01'
)

transactions.each do |transaction|
  puts transaction
end
```

### Get transaction

You can get a specific transaction by its id:

```ruby
require('starkbank')

transaction = StarkBank::Transaction.get(id: '5155165527080960')

puts transaction
```

### Create webhook subscription

To create a webhook subscription and be notified whenever an event occurs, run:

```ruby
require('starkbank')

webhook = StarkBank::Webhook.create(
  url: 'https://webhook.site/dd784f26-1d6a-4ca6-81cb-fda0267761ec',
  subscriptions: %w[transfer boleto boleto-payment utility-payment]
)

puts webhook
```

### Query webhooks

To search for registered webhooks, run:

```ruby
require('starkbank')

webhooks = StarkBank::Webhook.query()

webhooks.each do |webhook|
  puts webhook
end
```

### Get webhook

You can get a specific webhook by its id.

```ruby
require('starkbank')

webhook = StarkBank::Webhook.get(id: '10827361982368179')

puts webhook
```

### Delete webhook

You can also delete a specific webhook by its id.

```ruby
require('starkbank')

webhook = StarkBank::Webhook.delete(id: '10827361982368179')

puts webhook
```

### Process webhook events

Its easy to process events that arrived in your webhook. Remember to pass the
signature header so the SDK can make sure its really StarkBank that sent you
the event.

```ruby
require('starkbank')

response = listen()  # this is the method you made to get the events posted to your webhook

event = StarkBank::Event.parse(content: response.content, signature: response.headers['Digital-Signature'])

if event.subscription == 'transfer'
  puts event.log.transfer
elsif event.subscription == 'boleto'
  puts event.log.boleto
elsif event.subscription == 'boleto-payment'
  puts event.log.payment
elsif event.subscription == 'utility-payment'
  puts event.log.payment
end
```

### Query webhook events

To search for webhooks events, run:

```ruby
require('starkbank')

events = StarkBank::Event.query(after: '2020-03-20', is_delivered: false)

events.each do |event|
  puts event
end
```

### Get webhook event

You can get a specific webhook event by its id.

```ruby
require('starkbank')

event = StarkBank::Event.get(id: '10827361982368179')

puts event
```

### Delete webhook event

You can also delete a specific webhook event by its id.

```ruby
require('starkbank')

event = StarkBank::Event.delete(id: '10827361982368179')

puts event
```

### Set webhook events as delivered

This can be used in case you've lost events.
With this function, you can manually set events retrieved from the API as
"delivered" to help future event queries with `is_delivered: false`.

```ruby
require('starkbank')

event = StarkBank::Event.update(id: "129837198237192", is_delivered: true)

puts event
```

## Handling errors

The SDK may raise one of four types of errors: __InputErrors__, __InternalServerError__, __UnknownError__, __InvalidSignatureError__

__InputErrors__ will be raised whenever the API detects an error in your request (status code 400).
If you catch such an error, you can get its elements to verify each of the
individual errors that were detected in your request by the API.
For example:

```ruby
require('starkbank')

begin
  transactions = StarkBank::Transaction.create([
    Transaction.new(
      amount: 99999999999999,  # (R$ 999,999,999,999.99)
      receiver_d: "1029378109327810",
      description: ".",
      external_id: "12345",  # so we can block anything you send twice by mistake
      tags: %w[provider]
    ),
  ])
rescue StarkBank::Error:InputErrors => e
  e.errors.each do |error|
    puts error.code
    puts error.message
  end
end
```

__InternalServerError__ will be raised if the API runs into an internal error.
If you ever stumble upon this one, rest assured that the development team
is already rushing in to fix the mistake and get you back up to speed.

__UnknownError__ will be raised if a request encounters an error that is
neither __InputErrors__ nor an __InternalServerError__, such as connectivity problems.

__InvalidSignatureError__ will be raised specifically by starkbank.webhook.event.parse()
when the provided content and signature do not check out with the Stark Bank public
key.

## Key pair generation

The SDK provides a helper to allow you to easily create ECDSA secp256k1 keys to use
within our API. If you ever need a pair.new of keys, just run:

```ruby
require('starkbank')

private_key, public_key = StarkBank::Key.create()

# or, to also save .pem files in a specific path
private_key, public_key = StarkBank::Key.create('file/keys')
```

NOTE: When you are creating a Project.new, it is recommended that you create the
keys inside the infrastructure that will use it, in order to avoid risky internet
transmissions of your **private-key**. Then you can export the **public-key** alone to the
computer where it will be used in the Project.new creation.


[API docs]: (https://starkbank.com/docs/api/v2)