FROM centos:7

# set ruby version to be installed
ENV ruby_ver="2.6.5"
ENV rails_ver="6.0.1"

RUN yum -y update
RUN yum -y install epel-release
RUN yum -y install git make autoconf curl wget jq
RUN yum -y install gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel sqlite-devel bzip2 mariadb-client mariadb-devel
# mariadb
RUN curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash
RUN yum -y install  MariaDB-client MariaDB-shared
# nodejs v10 install
RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -
RUN yum -y install nodejs
# yarn install
RUN wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
RUN yum -y install yarn
RUN yum clean all

# rubyとbundleをダウンロード
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build

# コマンドでrbenvが使えるように設定
RUN echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="${RBENV_ROOT}/bin:${PATH}"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init --no-rehash -)"' >> /etc/profile.d/rbenv.sh
# rubyとrailsをインストール
# ADD rbenv.sh /etc/profile.d/rbenv.sh
RUN source /etc/profile.d/rbenv.sh; rbenv install ${ruby_ver}; rbenv global ${ruby_ver}
RUN source /etc/profile.d/rbenv.sh; gem update --system; gem install --version ${rails_ver} -N rails; gem install bundle

RUN mkdir -p /var/www/myrails
WORKDIR /var/www/myrails
ADD Gemfile /var/www/myrails/Gemfile
RUN touch /var/www/myrails/Gemfile.lock
#RUN source /etc/profile.d/rbenv.sh;  bundle install
#RUN cat /var/www/myrails/Gemfile
#ADD Gemfile /var/www/myrails/Gemfile
## railsプロジェクトを同名称で作成
#RUN source /etc/profile.d/rbenv.sh; rails new . -B --database=mysql --skip-turbolinks --skip-test --skip-bundle --path vendor/bundle
## webpacker install
#RUN source /etc/profile.d/rbenv.sh; rails webpacker:install
# RSPEC setup
# RUN source /etc/profile.d/rbenv.sh; rails g rspec:install
