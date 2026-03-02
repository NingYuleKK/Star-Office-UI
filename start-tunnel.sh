#!/bin/bash
# Star Office - Cloudflare Named Tunnel 启动脚本
# 使用固定域名 fengxiao.cc，不再需要写 tunnel-url.txt

echo "https://fengxiao.cc" > /Users/litch/Star-Office-UI/tunnel-url.txt

exec /opt/homebrew/bin/cloudflared tunnel run star-office
