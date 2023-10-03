require 'rails_helper'

describe 'User', type: :system do
  before { driven_by :selenium_chrome_headless }

  # ユーザー情報入力用の変数
  let(:email) { 'test@example.com' }
  let(:nickname) { 'テスト太郎' }
  let(:password) { 'password' }
  let(:password_confirmation) { password }

  describe 'ユーザー登録機能の検証' do
    before { visit '/users/sign_up' }

    # ユーザー登録を行う一連の操作を subject にまとめる
    subject do
      fill_in 'user_nickname', with: nickname
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: password_confirmation
      click_button 'ユーザー登録'
    end

    context '正常系' do
      it 'ユーザーを作成できる' do
        expect { subject }.to change(User, :count).by(1) # Userが1つ増える
        expect(current_path).to eq('/') # ユーザー登録後はトップページにリダイレクト
      end
    end
  end
end

describe 'ログイン機能の検証' do
  # 事前にユーザー作成
  before do
    create(:user, nickname: nickname, email: email, password: password, password_confirmation: password) # 事前にユーザー作成
    visit '/users/sign_in'
    fill_in 'user_email', with: email
    fill_in 'user_password', with: 'password'
    click_button 'ログイン'
  end
  context '正常系' do
    it 'ログインに成功し、トップページにリダイレクトする' do
      expect(current_path).to eq('/')
    end
  end
  context '異常系' do
    let(:password) { 'NGpassword' }
    it 'ログインに失敗し、ページ遷移しない' do
      expect(current_path).to eq('/users/sign_in')
    end
  end
end