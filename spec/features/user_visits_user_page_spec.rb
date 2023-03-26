require 'rails_helper'

RSpec.feature 'user views other profile', type: :feature do
  let!(:first_user) { FactoryGirl.create(:user, name: 'Андрей') }
  let(:second_user) { FactoryGirl.create(:user) }
  let!(:games) do
    [
      FactoryGirl.create(
        :game,
        user_id: first_user.id,
        is_failed: true,
        current_level: 6,
        prize: 10000,
        created_at: Time.parse('2023.03.25, 20:00'),
        finished_at: Time.parse('2023.03.25, 20:30')
      ),
      FactoryGirl.create(
        :game,
        user_id: first_user.id,
        is_failed: false,
        current_level: 7,
        prize: 5000,
        created_at: Time.parse('2023.03.21, 19:00'),
        finished_at: Time.parse('2023.03.21, 19:20')
      ),
      FactoryGirl.create(
        :game,
        user_id: first_user.id,
        is_failed: true,
        current_level: 12,
        prize: 140000,
        created_at: Time.parse('2023.03.23, 23:00'),
        finished_at: Time.parse('2023.03.23, 23:22')
      )
    ]
  end

  before { login_as second_user }

  scenario 'success' do
    visit user_path(first_user)
    save_and_open_page

    expect(page).to have_content('Андрей')
    expect(page).to have_content('проигрыш')
    expect(page).to have_content('деньги')
    expect(page).to have_content('25 марта, 20:00')
    expect(page).to have_content('21 марта, 19:00')
    expect(page).to have_content('23 марта, 23:00')
    expect(page).not_to have_content('Сменить имя и пароль')
    expect(page).to have_content('140 000 ₽')
    expect(page).to have_content('10 000 ₽')
    expect(page).to have_content('5 000 ₽')
    expect(page).to have_content('50/50')
    expect(page).to have_content('6')
    expect(page).to have_content('7')
    expect(page).to have_content('12')
  end
end
