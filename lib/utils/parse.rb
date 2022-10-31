require_relative '../../starkcore/lib/starkcore'

module StarkBank
    module Utils
        module Parse
            def self.parse_and_verify(content:, signature:, user: nil, resource:, key: nil)
                return StarkCore::Utils::Parse.parse_and_verify(
                    content: content, 
                    signature: signature, 
                    sdk_version: StarkBank::SDK_VERSION,
                    api_version: StarkBank::API_VERSION,
                    host: StarkBank::HOST,
                    resource: resource,
                    user: user ? user : StarkBank.user,
                    language: StarkBank.language,
                    timeout: StarkBank.language,
                    key: key
                )
            end
        end
    end
end