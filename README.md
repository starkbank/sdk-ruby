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

Feel free to take a look at our [API docs](https://www.starkbank.com/docs/api).

## Versioning

This project adheres to the following versioning pattern:

Given a version number MAJOR.MINOR.PATCH, increment:

- MAJOR version when the **API** version is incremented. This may include backwards incompatible changes;
- MINOR version when **breaking changes** are introduced OR **new functionalities** are added in a backwards compatible manner;
- PATCH version when backwards compatible bug **fixes** are implemented.

## Setup

### 1. Install our SDK

1.1 To install the package with gem, run:

```sh
gem install starkbank
```

1.2 Or just add this to your Gemfile:

```sh
gem('starkbank', '~> 2.1.0')
```

### 2. Create your Private and Public Keys

We use ECDSA. That means you need to generate a secp256k1 private
key to sign your requests to our API, and register your public key
with us so we can validate those requests.

You can use one of following methods:

2.1. Check out the options in our [tutorial](https://starkbank.com/faq/how-to-create-ecdsa-keys).

2.2. Use our SDK:

```ruby
require('starkbank')

private_key, public_key = StarkBank::Key.create

# or, to also save .pem files in a specific path
private_key, public_key = StarkBank::Key.create('file/keys')
```

**NOTE**: When you are creating a new Project, it is recommended that you create the
keys inside the infrastructure that will use it, in order to avoid risky internet
transmissions of your **private-key**. Then you can export the **public-key** alone to the
computer where it will be used in the new Project creation.

### 3. Create a Project

You need a project for direct API integrations. To create one in Sandbox:

3.1. Log into [Starkbank Sandbox](https://sandbox.web.starkbank.com)

3.2. Go to Menu > Usuários (Users) > Projetos (Projects)

3.3. Create a Project: Give it a name and upload the public key you created in section 2.

3.4. After creating the Project, get its Project ID

3.5. Use the Project ID and private key to create the object below:

```ruby
require('starkbank')

# Get your private key from an environment variable or an encrypted database.
# This is only an example of a private key content. You should use your own key.
private_key_content = '
-----BEGIN EC PARAMETERS-----
BgUrgQQACg==
-----END EC PARAMETERS-----
-----BEGIN EC PRIVATE KEY-----
MHQCAQEEIMCwW74H6egQkTiz87WDvLNm7fK/cA+ctA2vg/bbHx3woAcGBSuBBAAK
oUQDQgAE0iaeEHEgr3oTbCfh8U2L+r7zoaeOX964xaAnND5jATGpD/tHec6Oe9U1
IF16ZoTVt1FzZ8WkYQ3XomRD4HS13A==
-----END EC PRIVATE KEY-----
'

project = StarkBank::Project.new(
  environment: 'sandbox',
  id: '5656565656565656',
  private_key: private_key_content
)
```

NOTE 1: Never hard-code your private key. Get it from an environment variable or an encrypted database.

NOTE 2: We support `'sandbox'` and `'production'` as environments.

NOTE 3: The project you created in `sandbox` does not exist in `production` and vice versa.


### 4. Setting up the user

There are two kinds of users that can access our API: **Project** and **Member**.

- `Member` is the one you use when you log into our webpage with your e-mail.
- `Project` is designed for integrations and is the one meant for our SDK.

There are two ways to inform the user to the SDK:
 
4.1 Passing the user as argument in all functions:

```ruby
require('starkbank')

balance = StarkBank::Balance.get(user: project)
```

4.2 Set it as a default user in the SDK:

```ruby
require('starkbank')

StarkBank.user = project

balance = StarkBank::Balance.get()
```

Just select the way of passing the project user that is more convenient to you.
On all following examples we will assume a default user has been set.

### 5. Setting up the error language

The error language can also be set in the same way as the default user:


```ruby
require('starkbank')

StarkBank.language = 'en-US'
```

Language options are 'en-US' for english and 'pt-BR' for brazilian portuguese. English is default.


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

boletos = StarkBank::Boleto.create(
  [
    StarkBank::Boleto.new(
      amount: 23571,  # R 235,71 
      name: 'Buzz Aldrin',
      tax_id: '012.345.678-90', 
      street_line_1: 'Av. Paulista, 200', 
      street_line_2: '10 andar',
      district: 'Bela Vista', 
      city: 'São Paulo',
      state_code: 'SP',
      zip_code: '01310-000',
      due: Time.now + 24 * 3600,
      fine: 5,  # 5%
      interest: 2.5  # 2.5% per month
    )
  ]
)

boletos.each do |boleto|
  puts boleto
end
```

**Note**: Instead of using Boleto objects, you can also pass each boleto element in hash format

### Get boleto

After its creation, information on a boleto may be retrieved by passing its id. 
Its status indicates whether it's been paid.

```ruby
require('starkbank')

boleto = StarkBank::Boleto.get('6365512502083584')

puts boleto
```

### Get boleto PDF

After its creation, a boleto PDF may be retrieved by passing its id. 

```ruby
require('starkbank')

pdf = StarkBank::Boleto.pdf('6365512502083584', layout: 'default')

File.binwrite('boleto.pdf', pdf)
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

### Delete boleto

You can also cancel a boleto by its id.
Note that this is not possible if it has been processed already.

```ruby
require('starkbank')

boleto = StarkBank::Boleto.delete('5155165527080960')

puts boleto
```

### Query boletos

You can get a list of created boletos given some filters.

```ruby
require('starkbank')
require('date')

boletos = StarkBank::Boleto.query(
  after: '2020-01-01',
  before: Date.today - 1
)

boletos.each do |boleto|
  puts boleto
end
```

### Query boleto logs

Logs are pretty important to understand the life cycle of a boleto.

```ruby
require('starkbank')

logs = StarkBank::Boleto::Log.query(limit: 150)

logs.each do |log|
  puts log
end
```

### Get a boleto log

You can get a single log by its id.

```ruby
require('starkbank')

log = StarkBank::Boleto::Log.get('5155165527080960')

puts log
```

### Create transfers

You can also create transfers in the SDK (TED/DOC).

```ruby
require('starkbank')

transfers = StarkBank::Transfer.create(
  [
    StarkBank::Transfer.new(
      amount: 100,
      bank_code: '033',
      branch_code: '0001',
      account_number: '10000-0',
      tax_id: '012.345.678-90',
      name: 'Tony Stark',
      tags: %w[iron suit]
    ),
    StarkBank::Transfer.new(
      amount: 200,
      bank_code: '341',
      branch_code: '1234',
      account_number: '123456-7',
      tax_id: '012.345.678-90',
      name: 'Jon Snow',
      scheduled: Time.now + 24 * 3600,
      tags: []
    )
  ]
)

transfers.each do |transfer|
  puts transfer
end
```

**Note**: Instead of using Transfer objects, you can also pass each transfer element in hash format

### Query transfers

You can query multiple transfers according to filters.

```ruby
require('starkbank')

transfers = StarkBank::Transfer.query(
  after: '2020-01-01',
  before: '2020-04-01'
)

transfers.each do |transfer|
  puts transfer.name
end
```

### Get transfer

To get a single transfer by its id, run:

```ruby
require('starkbank')

transfer = StarkBank::Transfer.get('4804196796727296')

puts transfer
```

### Cancel a scheduled transfer

To cancel a single scheduled transfer by its id, run:

```ruby
require('starkbank')

transfer = StarkBank::Transfer.delete('4804196796727296')

puts transfer
```

### Get transfer PDF

A transfer PDF may also be retrieved by passing its id.
This operation is only valid if the transfer status is "processing" or "success". 

```ruby
require('starkbank')

pdf = StarkBank::Transfer.pdf('4832343898456064')

File.binwrite('transfer.pdf', pdf)
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

### Query transfer logs

You can query transfer logs to better understand transfer life cycles.

```ruby
require('starkbank')

logs = StarkBank::Transfer::Log.query(limit: 50)

logs.each do |log|
  puts log
end
```

### Get a transfer log

You can also get a specific log by its id.

```ruby
require('starkbank')

log = StarkBank::Transfer::Log.get('5554732936462336')

puts log
```

### Pay a boleto

Paying a boleto is also simple.

```ruby
require('starkbank')

payments = StarkBank::BoletoPayment.create(
  [
    StarkBank::BoletoPayment.new(
      line: '34191.09008 64694.197308 71444.640008 1 97230000028900',
      tax_id: '012.345.678-90',
      scheduled: Time.now,
      description: 'take my money',
      tags: %w[take my money]
    ),
    StarkBank::BoletoPayment.new(
      bar_code: '34191966100000145001090064694017307144464000',
      tax_id: '012.345.678-90',
      scheduled: Time.now + 24 * 3600,
      description: 'take my money one more time',
      tags: %w[again]
    )
  ]
)

payments.each do |payment|
  puts payment
end
```

**Note**: Instead of using BoletoPayment objects, you can also pass each payment element in hash format

### Get boleto payment

To get a single boleto payment by its id, run:

```ruby
require('starkbank')

payment = StarkBank::BoletoPayment.get('6591161082839040')

puts payment
```

### Get boleto payment PDF

After its creation, a boleto payment PDF may be retrieved by passing its id. 

```ruby
require('starkbank')

pdf = StarkBank::BoletoPayment.pdf('6591161082839040')

File.binwrite('boleto_payment.pdf', pdf)
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

### Delete boleto payment

You can also cancel a boleto payment by its id.
Note that this is not possible if it has been processed already.

```ruby
require('starkbank')

payment = StarkBank::BoletoPayment.delete('5155165527080960')

puts payment
```

### Query boleto payments

You can search for boleto payments using filters. 

```ruby
require('starkbank')

payments = StarkBank::BoletoPayment.query(
  tags: %w[company_1 company_2]
)

payments.each do |payment|
  puts payment
end
```

### Query boleto payment logs

Searches are also possible with boleto payment logs:

```ruby
require('starkbank')

logs = StarkBank::BoletoPayment::Log.query(
  payment_ids: %w[5391730421530624 6324396973096960]
)

logs.each do |log|
  puts log
end
```


### Get boleto payment log

You can also get a boleto payment log by specifying its id.

```ruby
require('starkbank')

log = StarkBank::BoletoPayment::Log.get('5155165527080960')

puts log
```

### Investigate a boleto

You can discover if a StarkBank boleto has been recently paid before we receive the response on the next day.
This can be done by creating a BoletoHolmes object, which fetches the updated status of the corresponding
Boleto object according to CIP to check, for example, whether it is still payable or not. The investigation
happens asynchronously and the most common way to retrieve the results is to register a 'boleto-holmes' webhook
subscription, although polling is also possible. 

```ruby
require('starkbank')
holmes = StarkBank::BoletoHolmes.create([
  StarkBank::BoletoHolmes.new(
    boleto_id: '5656565656565656'
  ),
  StarkBank::BoletoHolmes.new(
    boleto_id: '4848484848484848'
  )
])

holmes.each do |sherlock|
  puts sherlock
end
```

**Note**: Instead of using BoletoHolmes objects, you can also pass each payment element in hash format

### Get boleto holmes

To get a single Holmes by its id, run:

```ruby
require('starkbank')
sherlock = StarkBank::BoletoHolmes.get('19278361897236187236')

puts sherlock
```

### Query boleto holmes

You can search for boleto Holmes using filters. 

```ruby
require('starkbank')
holmes = StarkBank::BoletoHolmes.query(limit: 10, status: 'solved', before: DateTime.now).to_a

holmes.each do |sherlock|
  puts sherlock
end
```

### Query boleto holmes logs

Searches are also possible with boleto holmes logs:

```ruby
require('starkbank')
logs = StarkBank::BoletoHolmes::Log.query(limit: 10, types: 'solved').to_a

logs.each do |log|
  puts log
end
```

### Get boleto holmes log

You can also get a boleto holmes log by specifying its id.

```ruby
require('starkbank')
log = StarkBank::BoletoHolmes::Log.get('5155165527080960')

puts log
```

### Create utility payment

It's also simple to pay utility bills (such as electricity and water bills) in the SDK.

```ruby
require('starkbank')

payments = StarkBank::UtilityPayment.create(
  [
    StarkBank::UtilityPayment.new(
      line: '83680000001 7 08430138003 0 71070987611 8 00041351685 7',
      scheduled: Time.now,
      description: 'take my money',
      tags: %w[take my money],
    ),
    StarkBank::UtilityPayment.new(
      bar_code: '83600000001522801380037107172881100021296561',
      scheduled: Time.now + 3 * 24 * 3600,
      description: 'take my money one more time',
      tags: %w[again],
    )
  ]
)

payments.each do |payment|
  puts payment
end
```

**Note**: Instead of using UtilityPayment objects, you can also pass each payment element in hash format

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

payment = StarkBank::UtilityPayment.get('6258964706623488')

puts payment
```

### Get utility payment PDF

After its creation, a utility payment PDF may also be retrieved by passing its id. 

```ruby
require('starkbank')

pdf = StarkBank::UtilityPayment.pdf('5155165527080960')

File.binwrite('electricity_payment.pdf', pdf)
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

### Delete utility payment

You can also cancel a utility payment by its id.
Note that this is not possible if it has been processed already.

```ruby
require('starkbank')

payment = StarkBank::UtilityPayment.delete('6258964706623489')

puts payment
```

### Query utility payment logs

You can search for payments by specifying filters. Use this to understand the
bills life cycles.

```ruby
require('starkbank')

logs = StarkBank::UtilityPayment::Log.query(
  payment_ids: %w[102893710982379182 92837912873981273]
)

logs.each do |log|
  puts log
end
```

### Get utility bill payment log

If you want to get a specific payment log by its id, just run:

```ruby
require('starkbank')

log = StarkBank::UtilityPayment::Log.get('4922041111150592')

puts log
```

### Create transactions

To send money between Stark Bank accounts, you can create transactions:

```ruby
require('starkbank')

transactions = StarkBank::Transaction.create(
  [
    StarkBank::Transaction.new(
      amount: 100, # (R$ 1.00)
      receiver_id: '5083989094170624',
      description: 'Transaction to dear provider',
      external_id: '123456', # so we can block anything you send twice by mistake
      tags: %w[provider]
    ),
    StarkBank::Transaction.new(
      amount: 234, # (R$ 2.34)
      receiver_id: '5083989094170624',
      description: 'Transaction to the other provider',
      external_id: '123457', # so we can block anything you send twice by mistake
      tags: %w[provider]
    )
  ]
)

transactions.each do |transaction|
  puts transaction
end
```

**Note**: Instead of using Transaction objects, you can also pass each transaction element in hash format

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

transaction = StarkBank::Transaction.get('5764045667827712')

puts transaction
```

### Create payment requests to be approved by authorized people in a cost center 

You can also request payments that must pass through a specific cost center approval flow to be executed.
In certain structures, this allows double checks for cash-outs and also gives time to load your account
with the required amount before the payments take place.
The approvals can be granted at our website and must be performed according to the rules
specified in the cost center.

**Note**: The value of the center\_id parameter can be consulted by logging into our website and going
to the desired cost center page.

```ruby
require('starkbank')

requests = StarkBank::PaymentRequest.create(
  [
    StarkBank::PaymentRequest.new(
      center_id: '5967314465849344',
      due: Time.now + 24 * 3600,
      payment: StarkBank::Transfer.new(
        amount: 100,
        bank_code: '033',
        branch_code: '0001',
        account_number: '10000-0',
        tax_id: '012.345.678-90',
        name: 'Tony Stark',
      ),
      tags: %w[iron suit]
    )
  ]
)

requests.each do |request|
  puts request
end
```

**Note**: Instead of using PaymentRequest objects, you can also pass each boleto element in hash format


### Query payment requests

To search for payment requests, run:

```ruby
require('starkbank')
require('date')

requests = StarkBank::PaymentRequest.query(
  center_id: '5967314465849344',
  after: '2020-01-01',
  before: Date.today - 1
)

requests.each do |request|
  puts request
end
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

webhook = StarkBank::Webhook.get('10827361982368179')

puts webhook
```

### Delete webhook

You can also delete a specific webhook by its id.

```ruby
require('starkbank')

webhook = StarkBank::Webhook.delete('10827361982368179')

puts webhook
```

### Process webhook events

It's easy to process events that arrived in your webhook. Remember to pass the
signature header so the SDK can make sure it's really StarkBank that sent you
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

To search for webhook events, run:

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

event = StarkBank::Event.get('4828869076975616')

puts event
```

### Delete webhook event

You can also delete a specific webhook event by its id.

```ruby
require('starkbank')

event = StarkBank::Event.delete('4828869076975616')

puts event
```

### Set webhook events as delivered

This can be used in case you've lost events.
With this function, you can manually set events retrieved from the API as
"delivered" to help future event queries with `is_delivered: false`.

```ruby
require('starkbank')

event = StarkBank::Event.update('5892075044208640', is_delivered: true)

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
  transactions = StarkBank::Transaction.create(
    [
      StarkBank::Transaction.new(
        amount: 99999999999999,
        receiver_id: '1029378109327810',
        description: '.',
        external_id: '12345',
        tags: %w[provider]
      )
    ]
  )
rescue StarkBank::Error::InputErrors => e
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

__InvalidSignatureError__ will be raised specifically by StarkBank::Event.parse()
when the provided content and signature do not check out with the Stark Bank public
key.
