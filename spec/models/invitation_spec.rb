require 'rails_helper'

describe Invitation do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:game) }
  it { should validate_presence_of(:owner) }

  it { should belong_to(:user) }
  it { should belong_to(:game) }

  describe '#confirm!' do
    let(:invitation) { create(:invitation) }

    it 'confirmes invitation' do
      invitation.confirm!

      expect(invitation).to be_confirmed
    end
  end
end



