describe User do
  context 'associations' do
    it { should belong_to(:organisation) }
  end

  context 'validations' do
    it { should validate_presence_of(:name).on(:update) }

    describe "password and password confirmation must match" do
      let(:user) { create(:user, :confirmed, name: "Old name") }
      before do
        user.update(params)
      end

      context 'when passwords match' do
        let(:params) { { password: 'new_password', password_confirmation: 'new_password', name: "New name" } }

        it 'should set the users password' do
          expect(user.errors.empty?).to eq(true)
          expect(user.name).to eq("New name")
        end
      end

      context 'when passwords do not match' do
        let(:params) { { password: 'new_password', password_confirmation: 'other_password', name: "New name" } }

        it 'should not set the users password' do
          expect(user.reload.name).to eq("Old name")
          expect(user.errors.empty?).to eq(false)
          expect(user.errors.full_messages).to eq(["Password confirmation doesn't match Password"])
        end
      end

      context 'when password confirmation is missing' do
        let(:params) { { password: 'new_password', name: "New name" } }

        it 'should not set the users password' do
          expect(user.reload.name).to eq("Old name")
          expect(user.errors.empty?).to eq(false)
          expect(user.errors.full_messages).to eq(["Password confirmation doesn't match Password"])
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

  context 'permissions' do
    context 'a new user' do
      subject { create(:user, :confirmed) }

      it 'can manage team members' do
        expect(subject.can_manage_team?).to be_truthy
      end

      it 'can manage locations' do
        expect(subject.can_manage_locations?).to be_truthy
      end
    end
  end
end
