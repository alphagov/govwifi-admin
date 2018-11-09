describe User do
  context 'associations' do
    it { is_expected.to belong_to(:organisation) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name).on(:update) }

    describe 'password confirmation' do
      subject { create(:user, :confirmed) }

      before do
        subject.update(
          name: 'new name',
          password: 'new_password',
          password_confirmation: password_confirmation
        )
      end

      context 'matches password' do
        let(:password_confirmation) { 'new_password' }

        it { is_expected.to be_valid }

        it 'updates the name' do
          expect(subject.reload.name).to eq('new name')
        end
      end

      context 'does not match password' do
        let(:password_confirmation) { 'other_password' }

        it { is_expected.to_not be_valid }

        it 'does not update the name' do
          expect(subject.reload.name).to_not eq('new name')
        end

        it 'explains the error' do
          expect(subject.errors.full_messages).to include(
            "Password confirmation doesn't match Password"
          )
        end
      end

      context 'is blank' do
        let(:password_confirmation) { '' }

        it { is_expected.to_not be_valid }

        it 'does not update the name' do
          expect(subject.reload.name).to_not eq('new name')
        end

        it 'explains the error' do
          expect(subject.errors.full_messages).to include(
            "Password confirmation can't be blank"
          )
        end
      end
    end
  end

  describe '#save' do
    subject { build(:user, :confirmed) }

    context 'with the factory-built model' do
      it { is_expected.to be_valid }
    end

    context 'with valid data' do
      subject { build(:user, :confirmed, email: 'name@gov.uk') }

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
        subject { build(:user, :confirmed, email: 'name@arbitrary-domain.com') }

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
          user = create(:user, :confirmed)
          user.email = 'name@arbitrary-domain.com'
          user
        end

        it { is_expected.to be_valid }
      end
    end
  end
end
