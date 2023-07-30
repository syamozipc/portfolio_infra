#!/bin/bash

# パッケージインストール
yum update
yum install postgresql15.x86_64 -y

# serviceに登録
cat << EOF > /etc/systemd/system/${app_name}.service
[Unit]
Description=TODO application written by go
After=network.target

[Service]
Type=simple
WorkingDirectory=${work_dir}
ExecStart=/bin/bash -c '${work_dir}/main migrate; ${work_dir}/main serve'
Restart=always
Environment=DB_HOST=${db_host}
Environment=DB_PORT=${db_port}
Environment=DB_NAME=${db_name}
Environment=DB_USER=${db_user}
Environment=DB_PASSWORD=${db_password}

[Install]
WantedBy=multi-user.target
EOF

# 設定を読み込み
sudo systemctl daemon-reload
# インスタンス起動時に自動で有効化する
sudo systemctl enable ${app_name}.service

# 既にバイナリファイルが置かれている場合は実行（GitHub Actionsでビルド & アップロードする想定）
if [ -e ${work_dir}/main ]; then
  sudo systemctl start ${app_name}.service
fi
