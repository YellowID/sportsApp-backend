require 'rails_helper'

describe Game do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:sport_type) }
  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:level) }
  it { should validate_presence_of(:numbers) }
  it { should validate_presence_of(:age) }

  it { should belong_to(:user) }
  it { should belong_to(:sport_type) }

end



