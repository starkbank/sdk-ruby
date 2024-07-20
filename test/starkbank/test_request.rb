# frozen_string_literal: false

require_relative('../test_helper.rb')
require('securerandom')

describe(StarkBank::Request, '#request#') do
  it 'get success' do
    path = "/invoice"
    query = {"limit": 10}
    content = StarkBank::Request.get(path: path, query: query).json
    expect(content["invoices"][0]["id"]).wont_be_nil
  end

  it 'post success' do
    data = {
        "invoices": [
            {
                "name": "Jaime Lannister",
                "amount": 100,
                "taxId": "012.345.678-90"
            }
        ]
    }
    path = "/invoice"
    content = StarkBank::Request.post(path: path, payload: data).json
    expect(content["invoices"][0]["id"]).wont_be_nil
  end

  it 'patch success' do
    data = {
        "invoices": [
            {
                "name": "Jaime Lannister",
                "amount": 100,
                "taxId": "012.345.678-90"
            }
        ]
    }
    path = "/invoice"
    content = StarkBank::Request.post(path: path, payload: data).json

    content_id = content["invoices"][0]["id"]

    data = {"amount": 100}

    path = "/invoice/#{content_id}"
    content = StarkBank::Request.patch(path: path, payload: data).json

    expect(content["invoice"]["id"]).wont_be_nil
  end

  it 'put success' do
    data = {
        "profiles": [
            {
                "interval": "day",
                "delay": 10
            }
        ]
    }
    path = "/split-profile"
    content = StarkBank::Request.put(path: path, payload: data).json
    
    expect(content["profiles"][0]["id"]).wont_be_nil
  end

  it 'delete success' do
    data = {
        "transfers": [
            {
                "amount": 100,
                "name": "Jaime Lannister",
                "externalId": 'ruby-' + rand(1e10).to_s,
                "taxId": "012.345.678-90",
                "bankCode": "001",
                "branchCode": "1234",
                "accountNumber": "123456-0",
                "accountType": "checking"
            }
        ]
    }
    path = "/transfer"
    content = StarkBank::Request.post(path: path, payload: data).json

    path += "/#{content["transfers"][0]["id"]}"

    content = StarkBank::Request.delete(path: path).json

    expect(content["transfer"]["id"]).wont_be_nil
  end

end
