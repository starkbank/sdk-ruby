# Stark Bank Ruby SDK

Welcome to the Stark Bank Ruby SDK! This tool is made for Ruby 
developers who want to easily integrate with our API.
This SDK version is compatible with the Stark Bank API v2.

If you have no idea what Stark Bank is, check out our [website](https://www.starkbank.com/) 
and discover a world where receiving or making payments 
is as easy as sending a text message to your client!

# Introduction

# Index

- [Introduction](#introduction)
    - [Supported Ruby versions](#supported-ruby-versions)
    - [API documentation](#stark-bank-api-documentation)
    - [Versioning](#versioning)
- [Setup](#setup)
    - [Install our SDK](#1-install-our-sdk)
    - [Create your Private and Public Keys](#2-create-your-private-and-public-keys)
    - [Register your user credentials](#3-register-your-user-credentials)
    - [Setting up the user](#4-setting-up-the-user)
    - [Setting up the error language](#5-setting-up-the-error-language)
    - [Resource listing and manual pagination](#6-resource-listing-and-manual-pagination)
- [Testing in Sandbox](#testing-in-sandbox) 
- [Usage](#usage)
    - [Transactions](#create-transactions): Account statement entries
    - [Balance](#get-balance): Account balance
    - [Transfers](#create-transfers): Wire transfers (TED and manual Pix)
    - [DictKeys](#get-dict-key): Pix Key queries to use with Transfers
    - [Institutions](#query-bacen-institutions): Instutitions recognized by the Central Bank
    - [Invoices](#create-invoices): Reconciled receivables (dynamic Pix QR Codes)
    - [DynamicBrcode](#create-dynamicbrcodes): Simplified reconciled receivables (dynamic Pix QR Codes)
    - [Deposits](#query-deposits): Other cash-ins (static Pix QR Codes, DynamicBrcodes, manual Pix, etc)
    - [Boletos](#create-boletos): Boleto receivables
    - [BoletoHolmes](#investigate-a-boleto): Boleto receivables investigator
    - [BrcodePayments](#pay-a-br-code): Pay Pix QR Codes
    - [BoletoPayments](#pay-a-boleto): Pay Boletos
    - [UtilityPayments](#create-utility-payments): Pay Utility bills (water, light, etc.)
    - [TaxPayments](#create-tax-payments): Pay taxes
    - [DarfPayments](#create-darf-payment): Pay DARFs
    - [PaymentPreviews](#preview-payment-information-before-executing-the-payment): Preview all sorts of payments
    - [PaymentRequest](#create-payment-requests-to-be-approved-by-authorized-people-in-a-cost-center): Request a payment approval to a cost center
    - [CorporateHolders](#create-corporateholders): Manage cardholders
    - [CorporateCards](#create-corporatecard): Create virtual and/or physical cards
    - [CorporateInvoices](#create-corporateinvoices): Add money to your corporate balance
    - [CorporateWithdrawals](#create-corporatewithdrawals): Send money back to your Workspace from your corporate balance
    - [CorporateBalance](#get-your-corporatebalance): View your corporate balance
    - [CorporateTransactions](#query-corporatetransactions): View the transactions that have affected your corporate balance
    - [CorporateEnums](#corporate-enums): Query enums related to the corporate purchases, such as merchant categories, countries and card purchase methods
    - [Webhooks](#create-a-webhook-subscription): Configure your webhook endpoints and subscriptions
    - [WebhookEvents](#process-webhook-events): Manage webhook events
    - [WebhookEventAttempts](#query-failed-webhook-event-delivery-attempts-information): Query failed webhook event deliveries
    - [Workspaces](#create-a-new-workspace): Manage your accounts
- [Handling errors](#handling-errors)
- [Help and Feedback](#help-and-feedback)

# Supported Ruby Versions

This library supports the following Ruby versions:

* Ruby 2.3+

# Stark Bank API documentation

Feel free to take a look at our [API docs](https://www.starkbank.com/docs/api).

# Versioning

This project adheres to the following versioning pattern:

Given a version number MAJOR.MINOR.PATCH, increment:

- MAJOR version when the **API** version is incremented. This may include backwards incompatible changes;
- MINOR version when **breaking changes** are introduced OR **new functionalities** are added in a backwards compatible manner;
- PATCH version when backwards compatible bug **fixes** are implemented.

# Setup

## 1. Install our SDK

1.1 To install the package with gem, run:

```sh
gem install starkbank
```

1.2 Or just add this to your Gemfile:

```sh
gem('starkbank', '~> 2.8.0')
```

## 2. Create your Private and Public Keys

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

## 3. Register your user credentials

You can interact directly with our API using two types of users: Projects and Organizations.

- **Projects** are workspace-specific users, that is, they are bound to the workspaces they are created in.
One workspace can have multiple Projects.
- **Organizations** are general users that control your entire organization.
They can control all your Workspaces and even create new ones. The Organization is bound to your company's tax ID only.
Since this user is unique in your entire organization, only one credential can be linked to it.

3.1. To create a Project in Sandbox:

3.1.1. Log into [Starkbank Sandbox](https://web.sandbox.starkbank.com)

3.1.2. Go to Menu > Integrations

3.1.3. Click on the "New Project" button

3.1.4. Create a Project: Give it a name and upload the public key you created in section 2

3.1.5. After creating the Project, get its Project ID

3.1.6. Use the Project ID and private key to create the object below:

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

3.2. To create Organization credentials in Sandbox:

3.2.1. Log into [Starkbank Sandbox](https://web.sandbox.starkbank.com)

3.2.2. Go to Menu > Integrations

3.2.3. Click on the "Organization public key" button

3.2.4. Upload the public key you created in section 2 (only a legal representative of the organization can upload the public key)

3.2.5. Click on your profile picture and then on the "Organization" menu to get the Organization ID

3.2.6. Use the Organization ID and private key to create the object below:

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

organization = StarkBank::Organization.new(
    environment: 'sandbox',
    id: '5656565656565656',
    private_key: private_key_content,
    workspace_id: nil,  # You only need to set the workspace_id when you are operating a specific workspace_id
)

# To dynamically use your organization credentials in a specific workspace_id,
# you can use the Organization.replace() method:
balance = StarkBank::Balance.get(user: StarkBank::Organization.replace(organization, '4848484848484848'))

puts balance
```

NOTE 1: Never hard-code your private key. Get it from an environment variable or an encrypted database.

NOTE 2: We support `'sandbox'` and `'production'` as environments.

NOTE 3: The credentials you registered in `sandbox` do not exist in `production` and vice versa.


## 4. Setting up the user

There are three kinds of users that can access our API: **Organization**, **Project** and **Member**.

- `Project` and `Organization` are designed for integrations and are the ones meant for our SDKs.
- `Member` is the one you use when you log into our webpage with your e-mail.

There are two ways to inform the user to the SDK:
 
4.1 Passing the user as argument in all functions:

```ruby
require('starkbank')

balance = StarkBank::Balance.get(user: project) # or organization
```

4.2 Set it as a default user in the SDK:

```ruby
require('starkbank')

StarkBank.user = project # or organization

balance = StarkBank::Balance.get()
```

Just select the way of passing the user that is more convenient to you.
On all following examples we will assume a default user has been set.

## 5. Setting up the error language

The error language can also be set in the same way as the default user:


```ruby
require('starkbank')

StarkBank.language = 'en-US'
```

Language options are 'en-US' for english and 'pt-BR' for brazilian portuguese. English is default.

## 6. Resource listing and manual pagination

Almost all SDK resources provide a `query` and a `page` function.

- The `query` function provides a straight forward way to efficiently iterate through all results that match the filters you inform,
seamlessly retrieving the next batch of elements from the API only when you reach the end of the current batch.
If you are not worried about data volume or processing time, this is the way to go.

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

- The `page` function gives you full control over the API pagination. With each function call, you receive up to
100 results and the cursor to retrieve the next batch of elements. This allows you to stop your queries and
pick up from where you left off whenever it is convenient. When there are no more elements to be retrieved, the returned cursor will be `nil`.

```ruby
require('starkbank')

cursor = nil
transactions = nil
while true
  transactions, cursor = StarkBank::Transaction.page(limit: 5, cursor: cursor)
  transactions.each do |transaction|
    puts transaction
  end
  if cursor.nil?
    break
  end
end
```

To simplify the following SDK examples, we will only use the `query` function, but feel free to use `page` instead.

# Testing in Sandbox

Your initial balance is zero. For many operations in Stark Bank, you'll need funds
in your account, which can be added to your balance by creating an Invoice or a Boleto. 

In the Sandbox environment, most of the created Invoices and Boletos will be automatically paid,
so there's nothing else you need to do to add funds to your account. Just create
a few Invoices and wait around a bit.

In Production, you (or one of your clients) will need to actually pay this Invoice or Boleto
for the value to be credited to your account.


# Usage

Here are a few examples on how to use the SDK. If you have any doubts, check out
the function or class docstring to get more info or go straight to our [API docs].

## Create transactions

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

## Query transactions

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

## Get transaction

You can get a specific transaction by its id:

```ruby
require('starkbank')

transaction = StarkBank::Transaction.get('5764045667827712')

puts transaction
```

## Get balance

To know how much money you have in your workspace, run:

```ruby
require('starkbank')

balance = StarkBank::Balance.get()

puts balance
```

## Create transfers

You can also create transfers in the SDK (TED/Pix) and configure transfer behavior according to its rules.

```ruby
require('starkbank')

transfers = StarkBank::Transfer.create(
  [
    StarkBank::Transfer.new(
      amount: 100,
      bank_code: '033', # TED
      branch_code: '0001',
      account_number: '10000-0',
      tax_id: '012.345.678-90',
      name: 'Tony Stark',
      tags: %w[iron suit]
    ),
    StarkBank::Transfer.new(
      amount: 200,
      bank_code: '20018183', # Pix
      branch_code: '1234',
      account_number: '123456-7',
      account_type: 'salary',
      external_id: 'my-internal-id-12345',
      tax_id: '012.345.678-90',
      name: 'Jon Snow',
      scheduled: Time.now + 24 * 3600,
      tags: [],
      rules: [
        StarkBank::Transfer::Rule.new(
          key: 'resendingLimit',    # Set maximum number of retries if Transfer fails due to systemic issues at the receiver bank
          value: 5                  # Our resending limit is 10 by default
      ]
    )
  ]
)

transfers.each do |transfer|
  puts transfer
end
```

**Note**: Instead of using Transfer objects, you can also pass each transfer element in hash format

## Query transfers

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

## Get a transfer

To get a single transfer by its id, run:

```ruby
require('starkbank')

transfer = StarkBank::Transfer.get('4804196796727296')

puts transfer
```

## Cancel a scheduled transfer

To cancel a single scheduled transfer by its id, run:

```ruby
require('starkbank')

transfer = StarkBank::Transfer.delete('4804196796727296')

puts transfer
```

## Get a transfer PDF

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

## Query transfer logs

You can query transfer logs to better understand transfer life cycles.

```ruby
require('starkbank')

logs = StarkBank::Transfer::Log.query(limit: 50)

logs.each do |log|
  puts log
end
```

## Get a transfer log

You can also get a specific log by its id.

```ruby
require('starkbank')

log = StarkBank::Transfer::Log.get('5554732936462336')

puts log
```

## Get DICT key

You can get the Pix key's parameters by its id.

```ruby
require('starkbank')

dict_key = StarkBank::DictKey.get('tony@starkbank.com')

puts dict_key
```

## Query your DICT keys

To take a look at the Pix keys linked to your workspace, just run the following:
```ruby
require('starkbank')

dict_keys = StarkBank::DictKey.query(
  status: 'registered',
  type: 'evp'
  limit: 10
)

dict_keys.each do |dict_key|
  puts dict_key
end
```

## Query Bacen institutions

You can query institutions registered by the Brazilian Central Bank for Pix and TED transactions.

```ruby
require('starkbank')

institutions = StarkBank::Institution.query(search: 'stark').to_a

institutions.each do |institution|
  puts institution
end
```

## Create invoices

You can create dynamic QR Code invoices to charge customers or to receive money from accounts you have in other banks. 

Since the banking system only understands value modifiers (discounts, fines and interest) when dealing with **dates** (instead of **datetimes**), these values will only show up in the end user banking interface if you use **dates** in the "due" and "discounts" fields. 

If you use **datetimes** instead, our system will apply the value modifiers in the same manner, but the end user will only see the final value to be paid on his interface.

Also, other banks will most likely only allow payment scheduling on invoices defined with **dates** instead of **datetimes**.

```ruby
require('starkbank')

invoices = StarkBank::Invoice.create(
  [
    StarkBank::Invoice.new(
      amount: 23571,  # R$ 235,71 
      name: 'Buzz Aldrin',
      tax_id: '012.345.678-90', 
      due: Time.now + 24 * 3600,
      fine: 5,  # 5%
      interest: 2.5  # 2.5% per month
    )
  ]
)

invoices.each do |invoice|
  puts invoice
end
```

**Note**: Instead of using Invoice objects, you can also pass each invoice element in hash format

## Get an invoice

After its creation, information on an invoice may be retrieved by passing its id. 
Its status indicates whether it's been paid.

```ruby
require('starkbank')

invoice = StarkBank::Invoice.get('6365512502083584')

puts invoice
```

## Get an invoice QR Code

After its creation, an invoice QR Code png may be retrieved by passing its id. 

```ruby
require('starkbank')

png = StarkBank::Invoice.qrcode('6365512502083584')

File.binwrite('qrcode.png', png)
```

Be careful not to accidentally enforce any encoding on the raw png content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

## Get an invoice PDF

After its creation, an invoice PDF may be retrieved by passing its id. 

```ruby
require('starkbank')

pdf = StarkBank::Invoice.pdf('6365512502083584', layout: 'default')

File.binwrite('invoice.pdf', pdf)
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

## Cancel an invoice

You can also cancel an invoice by its id.
Note that this is not possible if it has been paid already.

```ruby
require('starkbank')

invoice = StarkBank::Invoice.update('5155165527080960', status: 'canceled')

puts invoice
```

## Update an invoice

You can update an invoice's amount, due date and expiration by its id.
Note that this is not possible if it has been paid already.

```ruby
require('starkbank')
require('date')

invoice = StarkBank::Invoice.update(
  '5155165527080960',
  amount: 100,
  expiration: 7200,  # 2 hours
  due: Time.now + 3600
)

puts invoice
```

## Query invoices

You can get a list of created invoices given some filters.

```ruby
require('starkbank')
require('date')

invoices = StarkBank::Invoice.query(
  after: '2020-01-01',
  before: Date.today - 1
)

invoices.each do |invoice|
  puts invoice
end
```

## Query invoice logs

Logs are pretty important to understand the life cycle of an invoice.

```ruby
require('starkbank')

logs = StarkBank::Invoice::Log.query(limit: 150)

logs.each do |log|
  puts log
end
```

## Get an invoice log

You can get a single log by its id.

```ruby
require('starkbank')

log = StarkBank::Invoice::Log.get('5155165527080960')

puts log
```

## Get a reversed invoice log PDF

Whenever an Invoice is successfully reversed, a reversed log will be created.
To retrieve a specific reversal receipt, you can request the corresponding log PDF:

```ruby
require('starkbank')

pdf = StarkBank::Invoice::Log.pdf('5155165527080960')
File.binwrite('invoice_log.pdf', pdf)
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

## Get an invoice payment information

Once an invoice has been paid, you can get the payment information using the InvoicePayment sub-resource:

```ruby
require('starkbank')

payment = StarkBank::Invoice.payment('5155165527080960');

puts payment
```

## Create DynamicBrcodes

You can create simplified dynamic QR Codes to receive money using Pix transactions. 
When a DynamicBrcode is paid, a Deposit is created with the tags parameter containing the character “dynamic-brcode/” followed by the DynamicBrcode’s uuid "dynamic-brcode/{uuid}" for conciliation.

The differences between an Invoice and the DynamicBrcode are the following:

|                       | Invoice | DynamicBrcode |
|-----------------------|:-------:|:-------------:|
| Expiration            |    ✓    |       ✓       |
| Can only be paid once |    ✓    |       ✓       |
| Due, fine and fee     |    ✓    |       X       |
| Discount              |    ✓    |       X       |
| Description           |    ✓    |       X       |
| Can be updated        |    ✓    |       X       |

**Note:** In order to check if a BR code has expired, you must first calculate its expiration date (add the expiration to the creation date). 
**Note:** To know if the BR code has been paid, you need to query your Deposits by the tag "dynamic-brcode/{uuid}" to check if it has been paid.

```ruby
require('starkbank')

brcodes = StarkBank::DynamicBrcode.create([
    StarkBank::DynamicBrcode.new(
      amount: 23571,  # R$ 235,71 
      expiration: 3600 * 3
    ),
    StarkBank::DynamicBrcode(
      amount: 23571,  # R$ 235,71 
      expiration: 3600 * 3
    )
])

brcodes.each do |brcode|
  puts brcode
end
```

**Note**: Instead of using DynamicBrcode objects, you can also pass each brcode element in dictionary format

## Get a DynamicBrcode

After its creation, information on a DynamicBrcode may be retrieved by its uuid.

```ruby
require('starkbank')

brcode = StarkBank::DynamicBrcode.get("bb9cd43ea6f4403391bf7ef6aa876600")

puts brcode
```

## Query DynamicBrcodes

You can get a list of created DynamicBrcodes given some filters.

```ruby
require('starkbank')

brcodes = StarkBank::DynamicBrcode.query(
    after: "2023-01-01",
    before: "2023-03-01"
)

brcodes.each do |brcode|
  puts brcode
end
```

## Query deposits

You can get a list of created deposits given some filters.

```ruby
require('starkbank')
require('date')

deposits = StarkBank::Deposit.query(
  after: '2020-01-01',
  before: Date.today - 1
)

deposits.each do |deposit|
  puts deposit
end
```

## Get a deposit

After its creation, information on a deposit may be retrieved by its id. 

```ruby
require('starkbank')

deposit = StarkBank::Deposit.get('6365512502083584')

puts deposit
```

## Query deposit logs

Logs are pretty important to understand the life cycle of a deposit.

```ruby
require('starkbank')

logs = StarkBank::Deposit::Log.query(limit: 150)

logs.each do |log|
  puts log
end
```

## Get a deposit log

You can get a single log by its id.

```ruby
require('starkbank')

log = StarkBank::Invoice::Log.get('5155165527080960')

puts log
```

## Create boletos

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

## Get a boleto

After its creation, information on a boleto may be retrieved by passing its id. 
Its status indicates whether it's been paid.

```ruby
require('starkbank')

boleto = StarkBank::Boleto.get('6365512502083584')

puts boleto
```

## Get a boleto PDF

After its creation, a boleto PDF may be retrieved by passing its id. 

```ruby
require('starkbank')

pdf = StarkBank::Boleto.pdf('6365512502083584', layout: 'default')

File.binwrite('boleto.pdf', pdf)
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

## Delete a boleto

You can also cancel a boleto by its id.
Note that this is not possible if it has been processed already.

```ruby
require('starkbank')

boleto = StarkBank::Boleto.delete('5155165527080960')

puts boleto
```

## Query boletos

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

## Query boleto logs

Logs are pretty important to understand the life cycle of a boleto.

```ruby
require('starkbank')

logs = StarkBank::Boleto::Log.query(limit: 150)

logs.each do |log|
  puts log
end
```

## Get a boleto log

You can get a single log by its id.

```ruby
require('starkbank')

log = StarkBank::Boleto::Log.get('5155165527080960')

puts log
```

## Investigate a boleto

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

## Get a boleto holmes

To get a single Holmes by its id, run:

```ruby
require('starkbank')
sherlock = StarkBank::BoletoHolmes.get('19278361897236187236')

puts sherlock
```

## Query boleto holmes

You can search for boleto Holmes using filters. 

```ruby
require('starkbank')
holmes = StarkBank::BoletoHolmes.query(limit: 10, status: 'solved', before: DateTime.now).to_a

holmes.each do |sherlock|
  puts sherlock
end
```

## Query boleto holmes logs

Searches are also possible with boleto holmes logs:

```ruby
require('starkbank')
logs = StarkBank::BoletoHolmes::Log.query(limit: 10, types: 'solved').to_a

logs.each do |log|
  puts log
end
```

## Get a boleto holmes log

You can also get a boleto holmes log by specifying its id.

```ruby
require('starkbank')
log = StarkBank::BoletoHolmes::Log.get('5155165527080960')

puts log
```

## Pay a BR Code

Paying a BRCode is also simple. After extracting the BRCode encoded in the Pix QR Code, you can do the following:

```ruby
require('starkbank')

payments = StarkBank::BrcodePayment.create(
  [
    StarkBank::BrcodePayment.new(
      line: '00020126580014br.gov.bcb.pix0136a629532e-7693-4846-852d-1bbff817b5a8520400005303986540510.005802BR5908T'Challa6009Sao Paulo62090505123456304B14A',
      tax_id:"012.345.678-90",
      scheduled: Time.now,
      description: "take my money",
      tags: %w[take my money],
      rules: [
        StarkBank::BrcodePayment::Rule.new(
          key: "resendingLimit",    # Set maximum number of retries if BrcodePayment fails due to systemic issues at the receiver bank
          value: 5                  # Our resending limit is 10 by default
      ]
    )
  ]
)

payments.each do |payment|
  puts payment
end
```

**Note**: You can also configure payment behavior according to its rules
**Note**: Instead of using BrcodePayment objects, you can also pass each payment element in hash format

## Get a BR Code payment

To get a single BR Code payment by its id, run:

```ruby
require('starkbank')

payment = StarkBank::BrcodePayment.get('6591161082839040')

puts payment
```

## Get a BR Code payment PDF

After its creation, a BR Code payment PDF may be retrieved by its id. 

```ruby
require('starkbank')

pdf = StarkBank::BrcodePayment.pdf('6591161082839040')

File.binwrite('brcode_payment.pdf', pdf)
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

## Cancel a BR Code payment

You can cancel a BR Code payment by changing its status to 'canceled'.
Note that this is not possible if it has been processed already.

```ruby
require('starkbank')

payment = StarkBank::BrcodePayment.update(
  '5155165527080960',
  status: 'canceled'
)

puts payment
```

## Query BR Code payments

You can search for brcode payments using filters. 

```ruby
require('starkbank')

payments = StarkBank::BrcodePayment.query(
  tags: %w[company_1 company_2]
)

payments.each do |payment|
  puts payment
end
```

## Query BR Code payment logs

Searches are also possible with BR Code payment logs:

```ruby
require('starkbank')

logs = StarkBank::BrcodePayment::Log.query(
  payment_ids: %w[5391730421530624 6324396973096960]
)

logs.each do |log|
  puts log
end
```

## Get a BR Code payment log

You can also get a BR Code payment log by specifying its id.

```ruby
require('starkbank')

log = StarkBank::BrcodePayment::Log.get('5155165527080960')

puts log
```

## Pay a boleto

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

## Get a boleto payment

To get a single boleto payment by its id, run:

```ruby
require('starkbank')

payment = StarkBank::BoletoPayment.get('6591161082839040')

puts payment
```

## Get a boleto payment PDF

After its creation, a boleto payment PDF may be retrieved by passing its id. 

```ruby
require('starkbank')

pdf = StarkBank::BoletoPayment.pdf('6591161082839040')

File.binwrite('boleto_payment.pdf', pdf)
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

## Delete a boleto payment

You can also cancel a boleto payment by its id.
Note that this is not possible if it has been processed already.

```ruby
require('starkbank')

payment = StarkBank::BoletoPayment.delete('5155165527080960')

puts payment
```

## Query boleto payments

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

## Query boleto payment logs

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


## Get a boleto payment log

You can also get a boleto payment log by specifying its id.

```ruby
require('starkbank')

log = StarkBank::BoletoPayment::Log.get('5155165527080960')

puts log
```

## Create utility payments

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

## Query utility payments

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

## Get a utility payment

You can get a specific bill by its id:

```ruby
require('starkbank')

payment = StarkBank::UtilityPayment.get('6258964706623488')

puts payment
```

## Get a utility payment PDF

After its creation, a utility payment PDF may also be retrieved by passing its id. 

```ruby
require('starkbank')

pdf = StarkBank::UtilityPayment.pdf('5155165527080960')

File.binwrite('electricity_payment.pdf', pdf)
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

## Delete a utility payment

You can also cancel a utility payment by its id.
Note that this is not possible if it has been processed already.

```ruby
require('starkbank')

payment = StarkBank::UtilityPayment.delete('6258964706623489')

puts payment
```

## Query utility payment logs

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

## Get a utility payment log

If you want to get a specific payment log by its id, just run:

```ruby
require('starkbank')

log = StarkBank::UtilityPayment::Log.get('4922041111150592')

puts log
```

## Create tax payments

It is also simple to pay taxes (such as ISS and DAS) using this SDK.

```ruby
require('starkbank')

payments = StarkBank.TaxPayment.create(
  [
    StarkBank::TaxPayment.new(
      bar_code: '85660000001549403280074119002551100010601813',
      description: 'fix the road',
      tags: ['take', 'my', 'money'],
      scheduled: '2020-08-13'
    ),
    StarkBank::TaxPayment.new(
      line: '85800000003 0 28960328203 1 56072020190 5 22109674804 0',
      description: 'build the hospital, hopefully',
      tags: ['expensive'],
      scheduled: '2020-08-13'
    )
  ]
)

payments.each do |payment|
  puts payment
end
```

**Note**: Instead of using TaxPayment objects, you can also pass each payment element in dictionary format

## Query tax payments

To search for tax payments using filters, run:

```ruby
require('starkbank')

payments = StarkBank::TaxPayment.query(limit: 5).to_a

payments.each do |payment|
  puts payment
end
```

## Get tax payment

You can get a specific tax payment by its id:

```ruby
require('starkbank')

payment = StarkBank::TaxPayment.get('5155165527080960')

puts payment
```

## Get tax payment PDF

After its creation, a tax payment PDF may also be retrieved by its id.

```ruby
require('starkbank')

pdf = StarkBank::TaxPayment.pdf('5155165527080960')
File.binwrite('tax_payment.pdf', pdf)
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

## Delete tax payment

You can also cancel a tax payment by its id.
Note that this is not possible if it has been processed already.

```ruby
require('starkbank')

payment = StarkBank::TaxPayment.delete('5155165527080960')

puts payment
```

## Query tax payment logs

You can search for payment logs by specifying filters. Use this to understand each payment life cycle.

```ruby
require('starkbank')

logs = StarkBank::TaxPayment::Log.query(limit: 5).to_a

logs.each do |log|
  puts log
end
```

## Get tax payment log

If you want to get a specific payment log by its id, just run:

```ruby
require('starkbank')

log = StarkBank::TaxPayment::Log.get('1902837198237992')

puts log
```

**Note**: Some taxes can't be payed with bar codes. Since they have specific parameters, each one of them has its own
resource and routes, which are all analogous to the TaxPayment resource. The ones we currently support are:
- DarfPayment, for DARFs

## Create DARF payment

If you want to manually pay DARFs without barcodes, you may create DarfPayments:

```ruby
require('starkbank')

payments = StarkBank::DarfPayment.create(
  [
    StarkBank::DarfPayment.new(
        revenue_code: "1240",
        tax_id: "012.345.678-90",
        competence: "2023-09-01",
        reference_number: "2340978970",
        nominal_amount: 1234,
        fine_amount: 12,
        interest_amount: 34,
        due: "2023-03-05",
        scheduled: "2023-03-05",
        tags: ["DARF", "making money"],
        description: "take my money",
    )
  ]
)

payments.each do |payment|
  puts payment
end
```

**Note**: Instead of using DarfPayment objects, you can also pass each payment element in dictionary format

## Query DARF payments

To search for DARF payments using filters, run:

```ruby
require('starkbank')

payments = StarkBank::DarfPayment.query(
    tags: ["darf", "july"]
).to_a

payments.each do |payment|
  puts payment
end
```

## Get DARF payment

You can get a specific DARF payment by its id:

```ruby
require('starkbank')

payment = StarkBank::DarfPayment.get('5155165527080960')

puts payment
```

## Get DARF payment PDF

After its creation, a DARF payment PDF may also be retrieved by its id. 

```ruby
require('starkbank')

pdf = StarkBank::DarfPayment.pdf('5155165527080960')
File.binwrite('tax_payment.pdf', pdf)
```

Be careful not to accidentally enforce any encoding on the raw pdf content,
as it may yield abnormal results in the final file, such as missing images
and strange characters.

## Delete DARF payment

You can also cancel a DARF payment by its id.
Note that this is not possible if it has been processed already.

```ruby
require('starkbank')

payment = StarkBank::DarfPayment.delete('5155165527080960')

puts payment
```

## Query DARF payment logs

You can search for payment logs by specifying filters. Use this to understand each payment life cycle.

```ruby
require('starkbank')

logs = StarkBank::DarfPayment::Log.query(limit: 5).to_a

logs.each do |log|
  puts log
end
```

## Get DARF payment log

If you want to get a specific payment log by its id, just run:

```ruby
require('starkbank')

log = StarkBank::DarfPayment::Log.get('1902837198237992')

puts log
```

## Preview payment information before executing the payment

You can preview multiple types of payment to confirm any information before actually paying.
If the "scheduled" parameter is not informed, today will be assumed as the intended payment date.
Right now, the "scheduled" parameter only has effect on BrcodePreviews.
This resource is able to preview the following types of payment:
"brcode-payment", "boleto-payment", "utility-payment" and "tax-payment"

```ruby
require('starkbank')

previews = StarkBank.PaymentPreview.create(
  [
    StarkBank::PaymentPreview.new(
      id: '00020126580014br.gov.bcb.pix0136a629532e-7693-4846-852d-1bbff817b5a8520400005303986540510.005802BR5908T\'Challa6009Sao Paulo62090505123456304B14A', 
      scheduled: '2020-08-13'
    ),
    StarkBank::PaymentPreview.new(
      id: '34191.09008 61207.727308 71444.640008 5 81310001234321'
    )
  ]
)

previews.each do |preview|
  puts preview
end
```

**Note**: Instead of using PaymentPreview objects, you can also pass each request element in dictionary format

## Create payment requests to be approved by authorized people in a cost center 

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


## Query payment requests

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

## Corporate

## Create CorporateHolders

You can create card holders to which your cards will be bound.
They support spending rules that will apply to all underlying cards.

```ruby
require('starkbank')

holders = StarkBank::CorporateHolder.create([
  StarkBank::CorporateHolder.new(
    name: "Iron Bank S.A.",
    tax_id: '0000',
    tags: ['012.345.678-90'],
    rules: [
      StarkBank::CorporateRule.new(
        name: "General USD",
        interval: "day",
        amount: 100000,
        currency_code: "USD"
      )
    ]
  )
])

holders.each do |holder|
    puts holder
end
```

**Note**: Instead of using CorporateHolder objects, you can also pass each element in dictionary format

## Query CorporateHolders

You can query multiple holders according to filters.

```ruby
require('starkbank')

holders = StarkBank::CorporateHolder.query()

holders.each do |holder|
  puts holder
end
```

## Cancel a CorporateHolder

To cancel a single Corporate Holder by its id, run:

```ruby
require('starkbank')

holder = StarkBank::CorporateHolder.cancel('5155165527080960')

puts holder
```

## Get a CorporateHolder

To get a single Corporate Holder by its id, run:

```ruby
require('starkbank')

holder = StarkBank::CorporateHolder.get('5155165527080960')

puts holder
```

## Query CorporateHolder logs

You can query holder logs to better understand holder life cycles.

```ruby
require('starkbank')

logs = StarkBank::CorporateHolder::Log.query(
  limit: 50, 
  after: '2022-01-01',
  before: '2022-01-20',
)

logs.each do |log|
  puts log
end
```

## Get a CorporateHolder log

You can also get a specific log by its id.

```ruby
require('starkbank')

log = StarkBank::CorporateHolder::Log.get('5155165527080960')

puts log
```

## Create CorporateCard

You can issue cards with specific spending rules.

```ruby
require('starkbank')

cards = StarkBank::CorporateCard.create([
  StarkBank::CorporateCard.new(
    holder_name: "Developers",
    holder_tax_id: "012.345.678-90",
    holder_external_id: "1234",
    rules: [
      StarkBank::CorporateRule.new(
        name: "General USD",
        interval: "day",
        amount: 100000,
        currency_code: "USD"
      )
    ]
  )
])

cards.each do |card|
    puts card
end
```

## Query CorporateCards

You can get a list of created cards given some filters.

```ruby
require('starkbank')

cards = StarkBank::CorporateCard.query(
  limit: 10,
  after: '2022-01-01',
  before: '2022-01-20',
)

cards.each do |card|
  puts card
end
```

## Get a CorporateCard

After its creation, information on a card may be retrieved by its id.

```ruby
require('starkbank')

card = StarkBank::CorporateCard.get('5155165527080960')

puts card
```

## Update a CorporateCard

You can update a specific card by its id.

```ruby
require('starkbank')

card = StarkBank::CorporateCard.update(
  '5155165527080960',
  status: 'blocked'
)

puts card
```

## Cancel a CorporateCard

You can also cancel a card by its id.

```ruby
require('starkbank')

card = StarkBank::CorporateCard.cancel('5155165527080960')

puts card
```

## Query CorporateCard logs

Logs are pretty important to understand the life cycle of a card.

```ruby
require('starkbank')

logs = StarkBank::CorporateCard::Log.query(
  limit: 50, 
  after: '2022-01-01',
  before: '2022-01-20',
)

logs.each do |log|
  puts log
end
```

## Get a CorporateCard log

You can get a single log by its id.

```ruby
require('starkbank')

log = StarkBank::CorporateCard::Log.get('5155165527080960')

puts log
```

## Query CorporatePurchases

You can get a list of created purchases given some filters.

```ruby
require('starkbank')

purchases = StarkBank::CorporatePurchase.query(
  limit: 10,
  after: '2022-01-01',
  before: '2022-01-20',
)

purchases.each do |purchase|
  puts purchase
end
```

## Get a CorporatePurchase

After its creation, information on a purchase may be retrieved by its id.

```ruby
require('starkbank')

purchase = StarkBank::CorporatePurchase.get('5155165527080960')

puts purchase
```

## Query CorporatePurchase logs

Logs are pretty important to understand the life cycle of a purchase.

```ruby
require('starkbank')

logs = StarkBank::CorporatePurchase::Log.query(
  limit: 50, 
  after: '2022-01-01',
  before: '2022-01-20',
)

logs.each do |log|
  puts log
end
```

## Get a CorporatePurchase log

You can get a single log by its id.

```ruby
require('starkbank')

log = StarkBank::CorporatePurchase::Log.get('5155165527080960')

puts log
```

## Create CorporateInvoices

You can create Pix invoices to transfer money from accounts you have in any bank to your Corporate balance,
allowing you to run your corporate operation.

```ruby
require('starkbank')

invoice = StarkBank::CorporateInvoice.create(
  StarkBank::CorporateInvoice.new(
    amount: 1000
  )
)

puts invoice
```

**Note**: Instead of using CorporateInvoice objects, you can also pass each element in dictionary format

## Query CorporateInvoices

You can get a list of created invoices given some filters.

```ruby
require('starkbank')

invoices = StarkBank::CorporateInvoice.query(
  limit: 10,
  after: '2022-01-01',
  before: '2022-01-20',
)

invoices.each do |invoice|
  puts invoice
end
```

## Create CorporateWithdrawals

You can create withdrawals to send cash back from your Corporate balance to your Banking balance
by using the Withdrawal resource.

```ruby
require('starkbank')

withdrawal = StarkBank::CorporateWithdrawal.create(
  StarkBank::CorporateWithdrawal.new(
    amount: 10_000,
    external_id: '123',
    description: 'Sending back'
  )
)

puts withdrawal
```

**Note**: Instead of using CorporateWithdrawal objects, you can also pass each element in dictionary format

## Get a CorporateWithdrawal

After its creation, information on a withdrawal may be retrieved by its id.

```ruby
require('starkbank')

withdrawal = StarkBank::CorporateWithdrawal.get('5155165527080960')

puts withdrawal
```

## Query CorporateWithdrawals

You can get a list of created withdrawals given some filters.

```ruby
require('starkbank')

withdrawals = StarkBank::CorporateWithdrawal.query(
  limit: 10,
  after: '2022-01-01',
  before: '2022-01-20',
)

withdrawals.each do |withdrawal|
  puts withdrawal
end
```

## Get your CorporateBalance

To know how much money you have available to run authorizations, run:

```ruby
require('starkbank')

balance = StarkBank::CorporateBalance.get()

puts balance
```

## Query CorporateTransactions

To understand your balance changes (corporate statement), you can query
transactions. Note that our system creates transactions for you when
you make purchases, withdrawals, receive corporate invoice payments, for example.

```ruby
require('starkbank')

transactions = StarkBank::CorporateTransaction.query(
  limit: 10,
  after: '2022-01-01',
  before: '2022-01-20',
)

transactions.each do |transaction|
  puts transaction
end
```

## Get a CorporateTransaction

You can get a specific transaction by its id:

```ruby
require('starkbank')

transaction = StarkBank::CorporateTransaction.get('5155165527080960')

puts transaction
```

## Corporate Enums

### Query MerchantCategories

You can query any merchant categories using this resource.
You may also use MerchantCategories to define specific category filters in CorporateRules.
Either codes (which represents specific MCCs) or types (code groups) will be accepted as filters.

```ruby
require('starkbank')

categories = StarkBank::MerchantCategory.query(
  search: 'food'
)

categories.each do |category|
  puts category
end
```

### Query MerchantCountries

You can query any merchant countries using this resource.
You may also use MerchantCountries to define specific country filters in CorporateRules.

```ruby
require('starkbank')

countries = StarkBank::MerchantCountry.query(
  search: 'brazil'
)

countries.each do |country|
  puts country
end
```

### Query CardMethods

You can query available card methods using this resource.
You may also use CardMethods to define specific purchase method filters in CorporateRules.

```ruby
require('starkbank')

methods = StarkBank::CardMethod.query(
  search: 'token',
)

methods.each do |method|
  puts method
end
```

## Create a webhook subscription

To create a webhook subscription and be notified whenever an event occurs, run:

```ruby
require('starkbank')

webhook = StarkBank::Webhook.create(
  url: 'https://webhook.site/dd784f26-1d6a-4ca6-81cb-fda0267761ec',
  subscriptions: %w[transfer invoice deposit brcode-payment boleto boleto-payment utility-payment tax-payment]
)

puts webhook
```

## Query webhooks

To search for registered webhooks, run:

```ruby
require('starkbank')

webhooks = StarkBank::Webhook.query()

webhooks.each do |webhook|
  puts webhook
end
```

## Get a webhook

You can get a specific webhook by its id.

```ruby
require('starkbank')

webhook = StarkBank::Webhook.get('10827361982368179')

puts webhook
```

## Delete a webhook

You can also delete a specific webhook by its id.

```ruby
require('starkbank')

webhook = StarkBank::Webhook.delete('10827361982368179')

puts webhook
```

## Process webhook events

It's easy to process events that arrived in your webhook. Remember to pass the
signature header so the SDK can make sure it's really StarkBank that sent you
the event.

```ruby
require('starkbank')

request = listen()  # this is the method you made to get the events posted to your webhook

event = StarkBank::Event.parse(content: request.body.read, signature: request.headers['Digital-Signature'])

if event.subscription == 'transfer'
  puts event.log.transfer
elsif event.subscription == 'deposit'
  puts event.log.deposit
elsif event.subscription == 'invoice'
  puts event.log.invoice
elsif event.subscription == 'brcode-payment'
  puts event.log.payment
elsif event.subscription == 'boleto'
  puts event.log.boleto
elsif event.subscription == 'boleto-payment'
  puts event.log.payment
elsif event.subscription == 'utility-payment'
  puts event.log.payment
end
```

## Query webhook events

To search for webhook events, run:

```ruby
require('starkbank')

events = StarkBank::Event.query(after: '2020-03-20', is_delivered: false)

events.each do |event|
  puts event
end
```

## Get a webhook event

You can get a specific webhook event by its id.

```ruby
require('starkbank')

event = StarkBank::Event.get('4828869076975616')

puts event
```

## Delete a webhook event

You can also delete a specific webhook event by its id.

```ruby
require('starkbank')

event = StarkBank::Event.delete('4828869076975616')

puts event
```

## Set webhook events as delivered

This can be used in case you've lost events.
With this function, you can manually set events retrieved from the API as
"delivered" to help future event queries with `is_delivered: false`.

```ruby
require('starkbank')

event = StarkBank::Event.update('5892075044208640', is_delivered: true)

puts event
```

## Query failed webhook event delivery attempts information

You can also get information on failed webhook event delivery attempts.

```ruby
require('starkbank')

attempts = StarkBank::Event::Attempt.query(after: '2020-03-20').to_a;

attempts.each do |attempt|
  puts attempt
end
```

## Get a failed webhook event delivery attempt information

To retrieve information on a single attempt, use the following function:

```ruby
require('starkbank')

attempt = StarkBank::Event::Attempt.get('1616161616161616')

puts attempt
```

## Create a new Workspace

The Organization user allows you to create new Workspaces (bank accounts) under your organization.
Workspaces have independent balances, statements, operations and users.
The only link between your Workspaces is the Organization that controls them.

**Note**: This route will only work if the Organization user is used with `workspace_id=nil`.

```ruby
require('starkbank')

workspace = StarkBank::Workspace.create(
    username: 'iron-bank-workspace-1',
    name: 'Iron Bank Workspace 1',
    user: organization,
)

puts workspace
```

## List your Workspaces

This route lists Workspaces. If no parameter is passed, all the workspaces the user has access to will be listed, but
you can also find other Workspaces by searching for their usernames or IDs directly.

```ruby
require('starkbank')

workspaces = StarkBank::Workspace.query(limit: 30)

workspaces.each do |workspace|
  puts workspace
end
```

## Get a Workspace

You can get a specific Workspace by its id.

```ruby
require('starkbank')

workspace = StarkBank.Workspace.get('10827361982368179')

puts workspace
```

## Update a Workspace

You can update a specific Workspace by its id.

```ruby
require('starkbank')

picture = open("path/to/picture.png", "rb").read()

updatedWorkspace = StarkBank::Workspace.update(
  workspace.ID, 
  username: 'new-username-test', 
  name: 'Updated workspace test', 
  allowed_tax_ids: ['20.018.183/0001-80'],
  picture: picture,
  picture_type: "image/png"
)

puts updatedWorkspace
```

You can also block a specific Workspace by its id.

```ruby
require('starkbank')

updatedWorkspace = StarkBank::Workspace.update(
  workspace.ID, 
  status: "blocked",
  user:starkbank.Organization.replace(organization, workspace.ID)
)

puts updatedWorkspace
```

# Handling errors

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

# Help and Feedback

If you have any questions about our SDK, just send us an email.
We will respond you quickly, pinky promise. We are here to help you integrate with us ASAP.
We also love feedback, so don't be shy about sharing your thoughts with us.

Email: help@starkbank.com
