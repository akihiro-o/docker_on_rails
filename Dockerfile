FROM centos:7

# set ruby version to be installed
ENV ruby_ver="2.7.2"
ENV rails_ver="6.0.3"

RUN yum -y update
RUN yum -y install epel-release
RUN yum -y install git make autoconf curl wget jq rsyslog
RUN yum -y install gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel sqlite-devel bzip2 mariadb-client mariadb-devel
RUN yum -y install freetds freetds-devel

# oracle-instantclient
RUN  curl -o /etc/yum.repos.d/public-yum-ol7.repo https://yum.oracle.com/public-yum-ol7.repo && \
     yum-config-manager --enable ol7_oracle_instantclient && \
     yum -y install --nogpgcheck oracle-instantclient18.3-basic oracle-instantclient18.3-devel oracle-instantclient18.3-sqlplus && \
     rm -rf /var/cache/yum && \
     echo /usr/lib/oracle/18.3/client64/lib > /etc/ld.so.conf.d/oracle-instantclient18.3.conf && \
     ldconfig
RUN echo 'export LD_LIBRARY_PATH="/usr/lib/oracle/18.3/client64/lib"' >> ~/.bash_profile
RUN echo 'export TNS_ADMIN="/usr/local/etc"' >> ~/.bash_profile
RUN echo 'export NLS_LANG="Japanese_Japan.AL32UTF8"' >> ~/.bash_profile
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
RUN echo "export RUBY_VER=${ruby_ver}">>/etc/profile.d/rbenv.sh
RUN echo 'export RAILS_ENV="development"' >> /etc/profile.d/rbenv.sh
RUN echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="${RBENV_ROOT}/bin:${PATH}"' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="${RBENV_ROOT}/versions/${RUBY_VER}/bin:${PATH}"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init --no-rehash -)"' >> /etc/profile.d/rbenv.sh
# rubyとrailsをインストール
# ADD rbenv.sh /etc/profile.d/rbenv.sh
RUN source /etc/profile.d/rbenv.sh; rbenv install ${ruby_ver}; rbenv global ${ruby_ver}
RUN source /etc/profile.d/rbenv.sh; gem update --system; gem install --version ${rails_ver} -N rails; gem install bundle -N ruby-oci8
RUN source /etc/profile.d/rbenv.sh; gem install sidekiq -N
RUN source /etc/profile.d/rbenv.sh; gem install tiny_tds -N

RUN mkdir -p /var/www/myrails
WORKDIR /var/www/myrails
ADD Gemfile /var/www/myrails/Gemfile
RUN touch /var/www/myrails/Gemfile.lock
RUN source /etc/profile.d/rbenv.sh;  bundle install

# overwrite /etc/syslog.conf,/etc/rsyslog.d/listen.conf
RUN sed -i -e '/$ModLoad imjournal/s/^/#/' /etc/rsyslog.conf
RUN sed -i -e 's/$OmitLocalLogging on/$OmitLocalLogging off/' /etc/rsyslog.conf
RUN sed -i -e '/$IMJournalStateFile/s/^/#/' /etc/rsyslog.conf
RUN sed -i -e '/$SystemLogSocketName/s/^/#/' /etc/rsyslog.d/listen.conf

## railsプロジェクトを同名称で作成
#RUN source /etc/profile.d/rbenv.sh; rails new . -B --database=mysql --skip-turbolinks --skip-test --skip-bundle --path vendor/bundle
## webpacker install
#RUN source /etc/profile.d/rbenv.sh; rails webpacker:install
# RSPEC setup
# RUN source /etc/profile.d/rbenv.sh; rails g rspec:install
