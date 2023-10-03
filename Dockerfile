# ベースイメージを指定
FROM ruby:3.2.2

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y postgresql-client curl wget
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && apt-get install -y nodejs npm

# Yarnのインストール
RUN npm install -g yarn

# Google Chromeのインストール
# RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# RUN apt install -y ./google-chrome-stable_current_amd64.deb

# アプリケーションディレクトリを作成
RUN mkdir /app
WORKDIR /app

# GemfileとGemfile.lockをコピーしてbundle installを実行
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

# アプリケーションのソースコードをコピー
COPY . /app

# entrypoint.shをコピーして実行権限を付与
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# entrypoint.shを実行
ENTRYPOINT ["entrypoint.sh"]

# ポート3000を公開
EXPOSE 3000

# Railsサーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]
