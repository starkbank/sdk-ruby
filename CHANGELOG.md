# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to the following versioning pattern:

Given a version number MAJOR.MINOR.PATCH, increment:

- MAJOR version when the **API** version is incremented. This may include backwards incompatible changes;
- MINOR version when **breaking changes** are introduced OR **new functionalities** are added in a backwards compatible manner;
- PATCH version when backwards compatible bug **fixes** are implemented.


## [Unreleased]
### Removed 
- account_created, created, owned attributes to DictKey resource
- account_number, branch_code attributes to PaymentPreview resource
### Changed
- account_number, branch_code attributes to DictKey resource
### Fixed 
- account_type docstring attribute to DictKey resource

## [2.10.0] - 2023-05-12
### Added
- purpose and schedule attributes to CorporateRule resource
- description attribute to CorporatePurchase::Log resource
- rules attribute to Invoice resource
- Invoice::Rule sub-resource

## [2.9.0] - 2023-05-04
### Added
- CorporateBalance resource
- CorporateCard resource
- CorporateHolder resource
- CorporateInvoice resource
- CorporatePurchase resource
- CorporateRule resource
- CorporateTransaction resource
- CorporateWithdrawal resource
- CardMethod sub-resource
- MerchantCategory sub-resource
- MerchantCountry sub-resource
### Changed
- StarkCore lib from 0.0.1 to 0.1.0

## [2.8.0] - 2023-03-23
### Added
- metadata attribute to Transfer resource

## [2.7.0] - 2023-03-16
### Added
- updated, type and transaction_ids attribute to UtilityPayment resource
- workspace_id attribute to Boleto resource
- updated attribute to BoletoHolmes::Log resource
- description attribute to PaymentRequest resource
- amount and transaction_ids attribute to BoletoPayment resource
- workspace_id attribute to Event resource
- transaction_ids attribute to DarfPayment and TaxPayment resources
- picture and picture_type parameters to update method on Workspace resource
- rules attribute to BrcodePayment resource
- BrcodePayment::Rule sub-resource
- rules attribute to Transfer resource
- Transfer::Rule sub-resource
- DynamicBrcode resource
- status, organization_id, picture_url and created attributes to Workspace resource
### Changed
- internal structure to use starkcore as a dependency.
### Removed
- deprecated BrcodePreview resource

## [2.6.0] - 2021-09-04
### Added
- PaymentPreview resource to preview multiple types of payments before confirmation: BrcodePreview, BoletoPreview, UtilityPreview and TaxPreview
- Support for scheduled invoices, which will display discounts, fine, interest, etc. on the users banking interface when dates are used instead of datetimes

## [2.5.0] - 2021-07-30
### Added
- "payment" account type for Pix related resources
- missing parameters to Boleto, BrcodePayment, Deposit, DictKey, Event, Invoice, Transfer and Workspace resources
- Workspace.update() to allow parameter updates
- Base exception class
- Invoice::Payment sub-resource to allow retrieval of invoice payment information
- Event::Attempt sub-resource to allow retrieval of information on failed webhook event delivery attempts
- pdf method for retrieving PDF receipts from reversed invoice logs
- page method as a manual-pagination alternative to queries
- Institution resource to allow query of institutions recognized by the Brazilian Central Bank for Pix and TED transactions
- TaxPayment resource
- DarfPayment resource
### Fixed
- special characters in brcodePreview query

## [2.4.0] - 2021-01-21
### Added
- Transfer.account_type property to allow 'checking', 'salary' or 'savings' account specification
- Transfer.external_id property to allow users to take control over duplication filters

## [2.3.0] - 2021-01-20
### Added
- Organization user
- Workspace resource

## [2.2.1] - 2020-11-16
### Fixed
- Invoice optional due parameter

## [2.2.0] - 2020-11-16
### Added
- Invoice resource to load your account with dynamic QR Codes
- DictKey resource to get Pix key's parameters
- Deposit resource to receive transfers passively
- Pix support in Transfer resource
- BrcodePayment support to pay static and dynamic Pix QR Codes

## [2.1.0] - 2020-10-28
### Added
- BoletoHolmes to investigate boleto status according to CIP

## [2.0.0] - 2020-10-19
### Added
- ids parameter to Transaction.query
- ids parameter to Transfer.query
- PaymentRequest resource to pass payments through manual approval flow

## [0.5.0] - 2020-08-20
### Added
- transfer.scheduled parameter to allow Transfer scheduling
- StarkBank::Transfer.delete to cancel scheduled Transfers
- Transaction query by tags

## [0.4.2] - 2020-06-24
### Changed
- Gem structure, now using Rake and minitest
### FIxed
- Non-implemented webhook subscription bug
- Circular require

## [0.4.1] - 2020-06-22
### Fixed
- starkbank-ecdsa dependency

## [0.4.0] - 2020-06-05
### Added
- Travis CI integration
- Boleto PDF layout option
- Global error language option
### Change
- Test user credentials to environment variable instead of hard-code

## [0.3.0] - 2020-05-12
### Added
- "receiver_name" & "receiver_tax_id" properties to Boleto entities

## [0.2.1] - 2020-05-05
### Fixed
- Docstrings


## [0.2.0] - 2020-05-04
### Added
- "discounts" property to Boleto entities
- Support for hashes in create methods
- "balance" property to Transaction entities
### Changed
- Internal folder structure
### Fixed
- Docstrings
- BoletoPayment spec

## [0.1.0] - 2020-04-17
### Added
- Full Stark Bank API v2 compatibility
