require 'rails_helper'

describe User do
  it { should validate_presence_of(:provider) }
  it { should validate_presence_of(:oauth_token) }
end

