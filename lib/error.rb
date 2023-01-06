# frozen_string_literal: true

require('starkcore')

module StarkBank
  module Error
    StarkBankError = StarkCore::Error::StarkCoreError

    Error = StarkCore::Error::Error

    InputErrors = StarkCore::Error::InputErrors

    InternalServerError = StarkCore::Error::InternalServerError

    UnknownError = StarkCore::Error::UnknownError

    InvalidSignatureError = StarkCore::Error::InvalidSignatureError
  end
end
