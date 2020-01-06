FROM redmine:4-alpine

# タイムゾーン設定
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# ビルド関係
RUN apk add --no-cache \
            curl \
            build-base \
            gcc \
            make

# gnu-iconv を導入
RUN apk add --no-cache \
            gnu-libiconv && \
    mv /usr/bin/iconv /usr/bin/iconv_orig && \
    ln -s /usr/bin/gnu-iconv /usr/bin/iconv

# 機密情報を投入
RUN mkdir -p /run/.secrets
COPY .secrets/* /run/.secrets/

# 設定変更
COPY config/configuration.yml /usr/src/redmine/config
RUN cat /run/.secrets/configuration_email_delivery.yml >> /usr/src/redmine/config/configuration.yml

# ヘルスチェックを追加
HEALTHCHECK --interval=15s --timeout=3s CMD wget -q http://localhost:3000 -O /dev/null || exit 1

# テーマ「farend bleuclair」を導入
RUN git clone -b redmine4.0 https://github.com/farend/redmine_theme_farend_bleuclair.git public/themes/bleuclair

# プラグイン「Theme Changer」を導入
RUN git clone -b 0.4.0 https://github.com/haru/redmine_theme_changer.git plugins/redmine_theme_changer

# プラグイン「Wiki Extensions」を導入
RUN git clone -b 0.9.0 https://github.com/haru/redmine_wiki_extensions.git plugins/redmine_wiki_extensions

# プラグイン「DMSF Plugin」を導入
# cf. https://github.com/danmunn/redmine_dmsf/issues/1065
RUN git clone -b devel-2.4.2 https://github.com/danmunn/redmine_dmsf.git plugins/redmine_dmsf

