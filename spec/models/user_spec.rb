describe User do
  context 'associations' do
    it { is_expected.to belong_to(:organisation) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name).on(:update) }
  end

  describe '#save' do
    subject { build(:user) }

    context 'with the factory-built model' do
      it { is_expected.to be_valid }
    end

    context 'with valid data' do
      subject { build(:user, email: 'name@gov.uk') }

      it { is_expected.to be_valid }

      context 'when saved' do
        before { subject.save }

        it 'saves the user' do
          expect(subject.persisted?).to be true
        end
      end
    end

    context 'with a non-gov.uk email' do
      context 'for a new record' do
        subject { build(:user, email: 'name@arbitrary-domain.com') }

        it { is_expected.to_not be_valid }

        context 'when saved' do
          before { subject.save }

          it 'explains the email must be from the correct domain' do
            expect(subject.errors.full_messages).to eq(
              ['Email must be from a government domain']
            )
          end
        end
      end

      context 'for an existing record' do
        subject do
          user = create(:user)
          user.email = 'name@arbitrary-domain.com'
          user
        end

        it { is_expected.to be_valid }
      end
    end
  end

  context 'permissions' do
    context 'a new user' do
      subject { create(:user) }

      it 'can manage team members' do
        expect(subject.can_manage_team?).to be_truthy
      end

      it 'can manage locations' do
        expect(subject.can_manage_locations?).to be_truthy
      end
    end
  end
end
